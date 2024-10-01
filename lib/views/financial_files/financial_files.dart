import 'package:churchapp/views/donations/financial/donnation_status.dart';
import 'package:churchapp/views/financial_files/chart_colors.dart';
import 'package:churchapp/views/financial_files/expense/expense_data.dart';
import 'package:churchapp/views/financial_files/expense/expenses.dart';
import 'package:churchapp/views/financial_files/expense/expenses_service.dart';
import 'package:churchapp/views/financial_files/financial_card_widgets.dart';
import 'package:churchapp/views/financial_files/revenue_data.dart';
import 'package:churchapp/views/financial_files/revenue_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:churchapp/views/financial_files/income/incomes.dart';
import 'package:churchapp/views/financial_files/upcomingEvents/upcoming_event.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Future<RevenueData> _revenueData;
  late Future<DonationStats> _donationStats;
  late Future<Map<String, double>> _annualExpensesData;
  late Future<ExpenseData> _expensesData;
  double totalAnnualExpenses = 0.0;
  final ExpensesService _expensesService = ExpensesService();

  @override
  void initState() {
    super.initState();
    RevenueService revenueService = RevenueService();

    _revenueData = revenueService.fetchAllRevenues();
    _donationStats = revenueService.fetchDonationStats();

    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear =
        DateTime(now.year + 1, 1, 1).subtract(const Duration(days: 1));

    _annualExpensesData =
        _expensesService.fetchAnnualExpenses(startOfYear, endOfYear);
    _expensesData = _expensesService.fetchData(startOfYear, endOfYear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChartColors.backgroundColor,
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

              final userFullName = _auth.currentUser?.displayName ?? 'User';
              totalAnnualExpenses =
                  expensesSnapshot.data!['totalAnnualExpenses'] ?? 0.0;

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

                  return FutureBuilder<ExpenseData>(
                    // Alterado para ExpenseData
                    future: _expensesData,
                    builder: (context, expensesSnapshot) {
                      if (expensesSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (expensesSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${expensesSnapshot.error}'));
                      }

                      if (!expensesSnapshot.hasData) {
                        return const Center(
                            child: Text('No expenses data found.'));
                      }

// Obtendo os dados

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            decoration: BoxDecoration(
                              color: ChartColors.accentColor,
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
                                        color: ChartColors.primaryTextColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      userFullName,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: ChartColors.primaryTextColor,
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
                                        color: ChartColors.cardBackgroundColor,
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(40),
                                          bottom: Radius.circular(40),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: ChartColors.cardShadowColor,
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          FinancialCardWidgets
                                              .buildFinancialCard(
                                            icon: Icons.account_balance,
                                            title: 'Saldo total',
                                            value:
                                                '€ ${totalBalance.toStringAsFixed(2)}',
                                            valueStyle: TextStyle(
                                              fontSize: 22,
                                              color: totalBalance >= 0
                                                  ? ChartColors.incomeColor
                                                  : ChartColors.expenseColor,
                                            ),
                                            withShadow: false,
                                            backgroundColor: Colors.white,
                                            titleStyle: TextStyle(
                                              fontSize: 22,
                                              color: ChartColors.cardTextColor,
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
                                                      color: ChartColors
                                                          .incomeColor,
                                                    ),
                                                    withShadow: false,
                                                    backgroundColor:
                                                        Colors.white,
                                                    titleStyle: TextStyle(
                                                      fontSize: 15,
                                                      color: ChartColors
                                                          .cardTextColor,
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
                                                      color: ChartColors
                                                          .expenseColor,
                                                    ),
                                                    withShadow: false,
                                                    backgroundColor:
                                                        Colors.white,
                                                    titleStyle: TextStyle(
                                                      fontSize: 15,
                                                      color: ChartColors
                                                          .cardTextColor,
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
                            child: FinancialCardWidgets.buildFinanceSectionCard(
                              icon: Icons.event_note,
                              title: 'Próximos Lançamentos',
                              value: '',
                              backgroundColor:
                                  ChartColors.cardBackOutgroundColor,
                              titleColor: ChartColors.cardTextColor,
                              valueColor: ChartColors.cardTextColor,
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
