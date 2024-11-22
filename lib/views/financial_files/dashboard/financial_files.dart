import 'package:churchapp/theme/theme_provider.dart';
import 'package:churchapp/views/financial_files/dashboard/revenue_service.dart';
import 'package:churchapp/views/financial_files/expense/expenses.dart';
import 'package:churchapp/views/financial_files/dashboard/monthly_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/data/model/user_data.dart';
import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:churchapp/views/financial_files/expense/expenses_service.dart';
import 'package:churchapp/views/financial_files/dashboard/financial_card_widgets.dart';
import 'package:churchapp/views/financial_files/dashboard/revenue_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:churchapp/views/financial_files/income/incomes.dart';
import 'package:churchapp/views/financial_files/upcomingEvents/upcoming_event.dart';
import 'package:provider/provider.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Future<RevenueData> _revenueData;
  late Future<DonationStats> _donationStats;
  late Future<Map<String, double>> _annualExpensesData;
  late Future<UserData> _userData;

  double totalAnnualExpenses = 0.0;
  final ExpensesService _expensesService = ExpensesService();
  double totalGeneralExpenses = 0.0;
  double totalSalaries = 0.0;
  double totalMaintenance = 0.0;
  double totalServices = 0.0;

  double monthlyGeneralExpenses = 0.0;
  double monthlySalaries = 0.0;
  double monthlyMaintenance = 0.0;
  double monthlyServices = 0.0;
  double totalMonthlyExpenses = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchAllExpenses();
    RevenueService revenueService = RevenueService();

    _revenueData = revenueService.fetchAllRevenues();
    _donationStats = revenueService.fetchDonationStats();

    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear =
        DateTime(now.year + 1, 1, 1).subtract(const Duration(days: 1));

    _annualExpensesData =
        _expensesService.fetchAnnualExpenses(startOfYear, endOfYear);
    _userData = fetchUserData();
  }

  Future<UserData> fetchUserData() async {
    String uid = _auth.currentUser!.uid;
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return UserData.fromDocument(doc);
  }

  Future<void> _fetchAllExpenses() async {
    try {
      final currentDate = DateTime.now();

      final annualExpensesData = await _expensesService.fetchAnnualExpenses(
        DateTime(currentDate.year, 1, 1),
        DateTime(currentDate.year + 1, 1, 1),
      );

      setState(() {
        totalGeneralExpenses =
            annualExpensesData['totalGeneralExpenses'] ?? 0.0;
        totalSalaries = annualExpensesData['totalSalaries'] ?? 0.0;
        totalMaintenance = annualExpensesData['totalMaintenance'] ?? 0.0;
        totalServices = annualExpensesData['totalServices'] ?? 0.0;

        totalAnnualExpenses = totalGeneralExpenses +
            totalSalaries +
            totalMaintenance +
            totalServices;
      });

      final monthlyExpensesData = await _expensesService.fetchMonthlyExpenses(
        DateTime(currentDate.year, currentDate.month, 1),
        DateTime(currentDate.year, currentDate.month + 1, 1),
      );

      setState(() {
        monthlyGeneralExpenses =
            monthlyExpensesData['totalGeneralExpenses'] ?? 0.0;
        monthlySalaries = monthlyExpensesData['totalSalaries'] ?? 0.0;
        monthlyMaintenance = monthlyExpensesData['totalMaintenance'] ?? 0.0;
        monthlyServices = monthlyExpensesData['totalServices'] ?? 0.0;

        totalMonthlyExpenses = monthlyGeneralExpenses +
            monthlySalaries +
            monthlyMaintenance +
            monthlyServices;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching expenses: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
    Color accentColor = isDarkMode ? Colors.grey[850]! : Colors.blue;
    Color cardBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.white;
    Color cardTextColor = isDarkMode ? Colors.white : Colors.black;
    Color incomeColor = isDarkMode ? Colors.white : Colors.green;
    Color expenseColor = isDarkMode ? Colors.white : Colors.red;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder<RevenueData>(
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
          final totalIncome = revenueData.totalIncomes;

          return FutureBuilder<Map<String, double>>(
            future: _annualExpensesData,
            builder: (context, expensesSnapshot) {
              if (expensesSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (expensesSnapshot.hasError) {
                return Center(child: Text('Error: ${expensesSnapshot.error}'));
              }

              if (!expensesSnapshot.hasData) {
                return const Center(
                    child: Text('Annual expenses data not found.'));
              }

              final totalBalance = totalIncome - totalAnnualExpenses;

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

                  return FutureBuilder<UserData>(
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

                      if (!userSnapshot.hasData) {
                        return const Center(
                            child: Text('User data not found.'));
                      }

                      final userData = userSnapshot.data!;

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              decoration: BoxDecoration(
                                color: accentColor,
                                borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(60)),
                              ),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 60.0, left: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bom Dia',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: cardTextColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        userData.fullName,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: cardTextColor,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0, horizontal: 16.0),
                                        decoration: BoxDecoration(
                                          color: cardBackgroundColor,
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(40),
                                                  bottom: Radius.circular(40)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: isDarkMode
                                                  ? Colors.black54
                                                  : Colors.grey
                                                      .withOpacity(0.5),
                                              blurRadius: 8.0,
                                              spreadRadius: 2.0,
                                              offset: const Offset(0.0, 2.0),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FinancialCardWidgets
                                                .buildFinancialCard(
                                              icon: Icons.account_balance,
                                              title: 'Balanço Anual',
                                              value:
                                                  '€ ${totalBalance.toStringAsFixed(2)}',
                                              valueStyle: TextStyle(
                                                fontSize: 22,
                                                color: totalBalance >= 0
                                                    ? incomeColor
                                                    : expenseColor,
                                              ),
                                              withShadow: false,
                                              backgroundColor:
                                                  cardBackgroundColor,
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
                                                                      donationStats),
                                                        ),
                                                      );
                                                    },
                                                    child: FinancialCardWidgets
                                                        .buildFinancialCard(
                                                      icon: Icons.trending_up,
                                                      title: 'Renda',
                                                      value:
                                                          '€ ${totalIncome.toStringAsFixed(2)}',
                                                      valueStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: incomeColor,
                                                      ),
                                                      withShadow: false,
                                                      backgroundColor:
                                                          cardBackgroundColor,
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
                                                    child: FinancialCardWidgets
                                                        .buildFinancialCard(
                                                      icon: Icons.trending_down,
                                                      title: 'Despesa',
                                                      value:
                                                          '€ ${totalAnnualExpenses.toStringAsFixed(2)}',
                                                      valueStyle: TextStyle(
                                                        fontSize: 14,
                                                        color: expenseColor,
                                                      ),
                                                      withShadow: false,
                                                      backgroundColor:
                                                          cardBackgroundColor,
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
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cardBackgroundColor.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isDarkMode
                                          ? Colors.black54
                                          : Colors.grey.withOpacity(0.5),
                                      blurRadius: 8.0,
                                      spreadRadius: 2.0,
                                      offset: const Offset(0.0, 2.0),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.event_note,
                                        color: cardTextColor),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Próximos Lançamentos',
                                      style: TextStyle(
                                        color: cardTextColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            MonthlyFinancialChart(
                              totalMonthlyExpenses: totalMonthlyExpenses,
                              totalMonthlyIncome: revenueData.monthlyIncomes,
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ),
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
