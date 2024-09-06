import 'package:churchapp/views/financial_files/expenses.dart';
import 'package:churchapp/views/financial_files/financial_analytics.dart';
import 'package:churchapp/views/financial_files/revenue_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:churchapp/views/financial_files/income/incomes.dart';
import 'package:churchapp/views/financial_files/transaction_history.dart';
import 'package:churchapp/views/financial_files/upcomingEvents/upcoming_event.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<Map<String, dynamic>> _userData;
  late Future<Map<String, double>> _revenueData;
  late RevenueService _revenueService;
  late Future<DonationStats> _donationStats;

  @override
  void initState() {
    super.initState();
    _userData = _fetchUserData();
    _revenueService = RevenueService();
    _revenueData = _fetchAllRevenues();
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

  Future<Map<String, double>> _fetchAllRevenues() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final donationStatsDoc =
        await _firestore.collection('donation_stats').doc(user.uid).get();
    final donationStats = DonationStats.fromMap(donationStatsDoc.data() ?? {});

    try {
      final revenues = await _revenueService.fetchAllRevenues(donationStats);

      final result = {
        'totalReceita': ((revenues['totalReceita'] ?? 0)),
        'monthlyReceita': ((revenues['monthlyReceita'] ?? 0)),
        'totalDonations': revenues['totalDonations'] ?? 0,
        'monthlyDonations': revenues['monthlyDonations'] ?? 0,
        'totalCourseRevenue': revenues['totalCourseRevenue'] ?? 0,
        'monthlyCourseRevenue': revenues['monthlyCourseRevenue'] ?? 0,
        'totalOverallIncome': revenues['totalOverallIncome'] ?? 0,
        'monthlyOtherIncome': revenues['monthlyOtherIncome'] ?? 0,
      };

      if (kDebugMode) {
        print('Dados obtidos: $result');
      }

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar receitas: $e');
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

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final primaryTextColor = isDarkMode ? Colors.white : Colors.black;
    final cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white;
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
                future: _revenueData,
                builder: (context, revenueSnapshot) {
                  if (revenueSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (revenueSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${revenueSnapshot.error}'));
                  }

                  if (!revenueSnapshot.hasData) {
                    return const Center(child: Text('Revenue data not found.'));
                  }

                  final revenues = revenueSnapshot.data!;
                  final totalReceita = revenues['totalReceita'] ?? 0.0;
                  final monthlyReceita = revenues['monthlyReceita'] ?? 0.0;
                  revenues['monthlyCourseRevenue'] ?? 0.0;
                  final totalOverallIncome =
                      revenues['totalOverallIncome'] ?? 0.0;

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
                              color: isDarkMode ? Colors.blueGrey : Colors.blue,
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(60),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 60.0, left: 16.0),
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
                                      totalOverallSum: totalOverallIncome,
                                      totalMonthlySum: monthlyReceita,
                                    ),
                                  ),
                                );
                              },
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
                                          GestureDetector(
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
                                              title: 'Total Receitas',
                                              value:
                                                  'R\$ ${totalReceita.toStringAsFixed(2)}',
                                              valueStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.green,
                                              ),
                                              withShadow: false,
                                              backgroundColor: Colors.white,
                                              titleStyle: TextStyle(
                                                fontSize: 15,
                                                color: primaryTextColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
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
                                                    title: 'Despesas',
                                                    value:
                                                        'R\$ ${0.0.toStringAsFixed(2)}',
                                                    valueStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.red,
                                                    ),
                                                    withShadow: false,
                                                    backgroundColor:
                                                        Colors.white,
                                                    titleStyle: TextStyle(
                                                      fontSize: 15,
                                                      color: primaryTextColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const TransactionHistoryScreen(),
                                                      ),
                                                    );
                                                  },
                                                  child: _buildFinancialCard(
                                                    icon: Icons.history,
                                                    title:
                                                        'Histórico de Transações',
                                                    value:
                                                        'R\$ ${totalReceita.toStringAsFixed(2)}',
                                                    valueStyle: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.blue,
                                                    ),
                                                    withShadow: false,
                                                    backgroundColor:
                                                        Colors.white,
                                                    titleStyle: TextStyle(
                                                      fontSize: 15,
                                                      color: primaryTextColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
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
                                            child: _buildFinancialCard(
                                              icon: Icons.event,
                                              title: 'Eventos Futuros',
                                              value:
                                                  'R\$ ${totalReceita.toStringAsFixed(2)}',
                                              valueStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.orange,
                                              ),
                                              withShadow: false,
                                              backgroundColor: Colors.white,
                                              titleStyle: TextStyle(
                                                fontSize: 15,
                                                color: primaryTextColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                });
          }),
    );
  }
}

Widget _buildFinancialCard({
  required IconData icon,
  required String title,
  required String value,
  required TextStyle valueStyle,
  bool withShadow = true,
  required Color backgroundColor,
  required TextStyle titleStyle,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: withShadow
          ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ]
          : null,
    ),
    child: Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: Colors.grey,
        ),
        const SizedBox(width: 16),
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
