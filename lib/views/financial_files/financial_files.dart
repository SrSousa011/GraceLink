import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:churchapp/views/financial_files/expenses.dart';
import 'package:churchapp/views/financial_files/financial_analytics.dart';
import 'package:churchapp/views/financial_files/income/incomes.dart';
import 'package:churchapp/views/financial_files/transaction_history.dart';
import 'package:churchapp/views/financial_files/upcomingEvents/upcoming_event.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<Map<String, dynamic>> _userData;
  late Future<Map<String, double>> _incomeData;
  late Future<DonationStats> _donationStats;

  @override
  void initState() {
    super.initState();
    _userData = _fetchUserData();
    _incomeData = _fetchIncomeData();
    _donationStats = _fetchDonationStats();
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      throw Exception('User data not found');
    }
  }

  Future<Map<String, double>> _fetchIncomeData() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);

    final querySnapshot = await _firestore
        .collection('transactions')
        .where('createdBy', isEqualTo: user.uid)
        .where('category', isEqualTo: 'income')
        .get();

    double totalOverallSum = 0;
    double totalMonthlySum = 0;

    for (final doc in querySnapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num).toDouble();
      final createdAt = (data['createdAt'] as Timestamp).toDate();

      totalOverallSum += amount;

      if (createdAt.isAfter(startOfMonth) && createdAt.isBefore(endOfMonth)) {
        totalMonthlySum += amount;
      }
    }

    return {
      'totalOverallSum': totalOverallSum,
      'totalMonthlySum': totalMonthlySum,
    };
  }

  Future<DonationStats> _fetchDonationStats() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final querySnapshot = await _firestore
        .collection('donations')
        .where('userId', isEqualTo: user.uid)
        .get();

    return DonationStats.fromDonations(querySnapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final primaryTextColor = isDarkMode ? Colors.white : Colors.black;
    final cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    final cardBackOutgroundColor = isDarkMode
        ? Colors.grey[800]!
        : const Color.fromARGB(255, 239, 241, 242);
    final cardTextColor = isDarkMode ? Colors.white : Colors.black;
    final accentColor = isDarkMode ? Colors.blueGrey : Colors.blue;
    final incomeColor =
        isDarkMode ? Colors.lightGreenAccent : Colors.lightGreen;
    final expenseColor = isDarkMode ? Colors.redAccent : Colors.red;

    final cardShadowColor = isDarkMode
        ? Colors.black.withOpacity(0.5)
        : Colors.black.withOpacity(0.2);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userData,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.hasError) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          }

          if (!userSnapshot.hasData) {
            return const Center(child: Text('User data not found.'));
          }

          final data = userSnapshot.data!;
          final userName = data['fullName'] ?? 'User';

          return FutureBuilder<Map<String, double>>(
            future: _incomeData,
            builder: (context, incomeSnapshot) {
              if (incomeSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (incomeSnapshot.hasError) {
                return Center(child: Text('Error: ${incomeSnapshot.error}'));
              }

              if (!incomeSnapshot.hasData) {
                return const Center(child: Text('Income data not found.'));
              }

              final incomeData = incomeSnapshot.data!;
              final totalOverallSum = incomeData['totalOverallSum'] ?? 0.0;
              final totalMonthlySum = incomeData['totalMonthlySum'] ?? 0.0;
              final totalExpenses = incomeData['totalExpenses'] ?? 1000.0;
              //final monthlyExpenses = incomeData['monthlyExpenses'] ?? 150.0;
              final totalBalance = totalOverallSum - totalExpenses;

              return FutureBuilder<DonationStats>(
                future: _donationStats,
                builder: (context, donationSnapshot) {
                  if (donationSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (donationSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${donationSnapshot.error}'));
                  }

                  if (!donationSnapshot.hasData) {
                    return const Center(
                        child: Text('Donation stats not found.'));
                  }

                  final donationStats = donationSnapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(60),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 60.0, left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bom Dia',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryTextColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  userName,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: primaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0.0, -80.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FinancialAnalytics(
                                  totalOverallSum: totalOverallSum,
                                  totalMonthlySum: totalMonthlySum,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    color: cardBackgroundColor,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(40),
                                      bottom: Radius.circular(40),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: cardShadowColor,
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FinancialAnalytics(
                                                totalOverallSum:
                                                    totalOverallSum,
                                                totalMonthlySum:
                                                    totalMonthlySum,
                                              ),
                                            ),
                                          );
                                        },
                                        child: _buildFinancialCard(
                                          icon: Icons.account_balance,
                                          title: 'Saldo total',
                                          value:
                                              '€ ${totalBalance.toStringAsFixed(2)}',
                                          valueStyle: TextStyle(
                                            fontSize: 22,
                                            color: totalBalance >= 0
                                                ? incomeColor
                                                : expenseColor,
                                          ),
                                          withShadow: false,
                                          backgroundColor: Colors.white,
                                          titleStyle: TextStyle(
                                            fontSize: 22,
                                            color: cardTextColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        IncomesScreen(
                                                      donationStats:
                                                          donationStats,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: _buildFinancialCard(
                                                icon: Icons.trending_up,
                                                title: 'Renda',
                                                value:
                                                    '€ ${totalOverallSum.toStringAsFixed(2)}',
                                                valueStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: incomeColor,
                                                ),
                                                withShadow: false,
                                                backgroundColor: Colors.white,
                                                titleStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: cardTextColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 1),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ExpensesScreen(),
                                                  ),
                                                );
                                              },
                                              child: _buildFinancialCard(
                                                icon: Icons.trending_down,
                                                title: 'Despesa',
                                                value:
                                                    '€ ${totalExpenses.toStringAsFixed(2)}',
                                                valueStyle: TextStyle(
                                                  fontSize: 14,
                                                  color: expenseColor,
                                                ),
                                                withShadow: false,
                                                backgroundColor: Colors.white,
                                                titleStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: cardTextColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const UpcomingEventsScreen(),
                            ),
                          );
                        },
                        child: _buildFinanceSectionCard(
                          icon: Icons.event_note,
                          title: 'Próximos Lançamentos',
                          value: '',
                          backgroundColor: cardBackOutgroundColor,
                          titleColor: cardTextColor,
                          valueColor: cardTextColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TransactionHistoryScreen(),
                            ),
                          );
                        },
                        child: _buildFinanceSectionCard(
                          icon: Icons.history,
                          title: 'Histórico de Transações',
                          value: '',
                          backgroundColor: cardBackOutgroundColor,
                          titleColor: cardTextColor,
                          valueColor: cardTextColor,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

Widget _buildFinanceSectionCard({
  required IconData icon,
  required String title,
  required String value,
  required Color backgroundColor,
  required Color titleColor,
  required Color valueColor,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(
          icon,
          color: titleColor,
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildFinancialCard({
  required IconData icon,
  required String title,
  required String value,
  TextStyle? valueStyle,
  bool withShadow = true,
  Color backgroundColor = Colors.white,
  required TextStyle titleStyle,
  Color iconColor = Colors.teal,
}) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      boxShadow: withShadow
          ? [
              BoxShadow(
                color: iconColor.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
          : [],
    ),
    child: Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: titleStyle,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: valueStyle,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
