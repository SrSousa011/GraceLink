import 'package:churchapp/data/model/user_data.dart';
import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:churchapp/views/financial_files/currency_convert.dart';
import 'package:churchapp/views/financial_files/expense/expenses_service.dart';
import 'package:churchapp/views/financial_files/revenue_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:churchapp/views/financial_files/expense/expenses.dart';
import 'package:churchapp/views/financial_files/income/incomes.dart';
import 'package:churchapp/views/financial_files/upcomingEvents/upcoming_event.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Future<Map<String, double>> _revenueData;
  late Future<DonationStats> _donationStats;
  late Future<Map<String, double>> _annualExpenses;
  late Future<UserData?> _userData;

  final RevenueService _revenueService = RevenueService();
  final ExpensesService _expensesService = ExpensesService();

  @override
  void initState() {
    super.initState();
    _revenueData = _fetchAllRevenues();
    _donationStats = _fetchDonationStats();
    _annualExpenses = _fetchAnnualExpenses();
    _userData = _fetchUserData();
  }

  Future<Map<String, double>> _fetchAllRevenues() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final donationStatsQuery = await _firestore
        .collection('donations')
        .where('userId', isEqualTo: user.uid)
        .get();

    final donationStats = DonationStats.fromDonations(donationStatsQuery.docs);

    try {
      final revenues = await _revenueService.fetchAllRevenues(donationStats);

      return {
        'totalReceita': revenues['totalReceita'] ?? 0.0,
        'monthlyReceita': revenues['monthlyReceita'] ?? 0.0,
        'totalDonations': revenues['totalDonations'] ?? 0.0,
        'monthlyDonations': revenues['monthlyDonations'] ?? 0.0,
        'totalCourseRevenue': revenues['totalCourseRevenue'] ?? 0.0,
        'monthlyCourseRevenue': revenues['monthlyCourseRevenue'] ?? 0.0,
        'totalOverallIncome': revenues['totalOverallIncome'] ?? 0.0,
        'monthlyOtherIncome': revenues['monthlyOtherIncome'] ?? 0.0,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching revenues: $e');
      }
      return {
        'totalReceita': 0.0,
        'monthlyReceita': 0.0,
        'totalDonations': 0.0,
        'monthlyDonations': 0.0,
        'totalCourseRevenue': 0.0,
        'monthlyCourseRevenue': 0.0,
        'totalOverallIncome': 0.0,
        'monthlyOtherIncome': 0.0,
      };
    }
  }

  Future<Map<String, double>> _fetchAnnualExpenses() async {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear =
        DateTime(now.year + 1, 1, 1).subtract(const Duration(days: 1));

    return await _expensesService.fetchAnnualExpenses(startOfYear, endOfYear);
  }

  Future<DonationStats> _fetchDonationStats() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      final querySnapshot = await _firestore
          .collection('donations')
          .where('userId', isEqualTo: user.uid)
          .get();

      return DonationStats.fromDonations(querySnapshot.docs);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching donation stats: $e');
      }
      return DonationStats(totalDonation: 0.0, monthlyDonation: 0.0);
    }
  }

  Future<UserData?> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }

    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      return UserData.fromDocument(userDoc);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final containerBackground = isDarkMode ? Colors.grey[800]! : Colors.white;
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
      body: FutureBuilder<Map<String, double>>(
        future: _revenueData,
        builder: (context, revenueSnapshot) {
          if (revenueSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (revenueSnapshot.hasError) {
            return Center(child: Text('Error: ${revenueSnapshot.error}'));
          }

          if (!revenueSnapshot.hasData) {
            return const Center(child: Text('Revenue data not found.'));
          }

          final revenueData = revenueSnapshot.data!;
          final totalReceita = revenueData['totalReceita'] ?? 0.0;

          return FutureBuilder<Map<String, double>>(
            future: _annualExpenses,
            builder: (context, expensesSnapshot) {
              if (expensesSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (expensesSnapshot.hasError) {
                return Center(child: Text('Error: ${expensesSnapshot.error}'));
              }

              if (!expensesSnapshot.hasData) {
                return const Center(child: Text('Expense data not found.'));
              }

              final expensesData = expensesSnapshot.data!;
              final totalAnnualExpenses =
                  expensesData['totalAnnualExpenses'] ?? 0.0;
              final totalBalance = totalReceita - totalAnnualExpenses;

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

                  return FutureBuilder<UserData?>(
                    future: _userData,
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (userSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${userSnapshot.error}'));
                      }

                      final userData = userSnapshot.data;
                      final userName = userData?.fullName ?? 'User';

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
                                padding: const EdgeInsets.only(
                                    top: 40.0, left: 24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bem-vindo',
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
                              onTap: () {},
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Center(
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0, horizontal: 16.0),
                                        decoration: BoxDecoration(
                                          color: cardBackgroundColor,
                                          borderRadius:
                                              const BorderRadius.vertical(
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
                                            _buildFinancialCard(
                                              icon: Icons.account_balance,
                                              title: 'Saldo total',
                                              value: CurrencyConverter.format(
                                                  totalBalance),
                                              valueStyle: TextStyle(
                                                fontSize: 22,
                                                color: totalBalance >= 0
                                                    ? incomeColor
                                                    : expenseColor,
                                              ),
                                              withShadow: false,
                                              backgroundColor:
                                                  containerBackground,
                                              titleStyle: TextStyle(
                                                fontSize: 22,
                                                color: cardTextColor,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                      value: CurrencyConverter
                                                          .format(totalReceita),
                                                      valueStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: incomeColor,
                                                      ),
                                                      withShadow: false,
                                                      backgroundColor:
                                                          containerBackground,
                                                      titleStyle: TextStyle(
                                                        fontSize: 15,
                                                        color: cardTextColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
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
                                                      value: CurrencyConverter
                                                          .format(
                                                              totalAnnualExpenses),
                                                      valueStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: expenseColor,
                                                      ),
                                                      withShadow: false,
                                                      backgroundColor:
                                                          containerBackground,
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
                                        )),
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
                        ],
                      );
                    },
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

Widget _buildFinancialCard({
  required IconData icon,
  required String title,
  required String value,
  required TextStyle valueStyle,
  required bool withShadow,
  required Color backgroundColor,
  required TextStyle titleStyle,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      boxShadow: withShadow
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
          : [],
    ),
    child: Row(
      children: [
        Icon(icon, size: 30, color: valueStyle.color),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: titleStyle),
              const SizedBox(height: 8),
              Text(value, style: valueStyle),
            ],
          ),
        ),
      ],
    ),
  );
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
    padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    ),
    child: Row(
      children: [
        Icon(icon, size: 30, color: titleColor),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 18, color: titleColor)),
              const SizedBox(height: 8),
              Text(value, style: TextStyle(fontSize: 16, color: valueColor)),
            ],
          ),
        ),
      ],
    ),
  );
}
