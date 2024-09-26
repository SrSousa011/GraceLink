import 'package:churchapp/views/financial_files/currency_convert.dart';
import 'package:churchapp/views/financial_files/expense/expenses_service.dart';
import 'package:churchapp/views/financial_files/financialData.dart';
import 'package:churchapp/views/financial_files/financial_card_widget.dart';
import 'package:churchapp/views/financial_files/revenue_service.dart';
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
  late Future<FinancialData> _financialData;

  @override
  void initState() {
    super.initState();
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final revenueService = RevenueService();
    final expensesService = ExpensesService();

    final financialService = FinancialService(
      auth: auth,
      firestore: firestore,
      revenueService: revenueService,
      expensesService: expensesService,
    );

    _financialData = financialService.fetchAllFinancialData();
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
      body: FutureBuilder<FinancialData>(
        future: _financialData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Financial data not found.'));
          }

          final financialData = snapshot.data!;
          final totalReceita = financialData.revenues['totalReceita'] ?? 0.0;
          final totalAnnualExpenses =
              financialData.annualExpenses['totalAnnualExpenses'] ?? 0.0;
          final totalBalance = totalReceita - totalAnnualExpenses;

          final userName = financialData.userData?.fullName ?? 'User';

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
                    padding: const EdgeInsets.only(top: 40.0, left: 24.0),
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
                              FinancialCardWidgets.buildFinancialCard(
                                icon: Icons.account_balance,
                                title: 'Saldo total',
                                value: CurrencyConverter.format(totalBalance),
                                valueStyle: TextStyle(
                                  fontSize: 22,
                                  color: totalBalance >= 0
                                      ? incomeColor
                                      : expenseColor,
                                ),
                                withShadow: false,
                                backgroundColor: containerBackground,
                                titleStyle: TextStyle(
                                  fontSize: 22,
                                  color: cardTextColor,
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
                                            builder: (context) => IncomesScreen(
                                              donationStats:
                                                  financialData.donationStats,
                                            ),
                                          ),
                                        );
                                      },
                                      child: FinancialCardWidgets
                                          .buildFinancialCard(
                                        icon: Icons.trending_up,
                                        title: 'Renda',
                                        value: CurrencyConverter.format(
                                            totalReceita),
                                        valueStyle: TextStyle(
                                          fontSize: 14,
                                          color: incomeColor,
                                        ),
                                        withShadow: false,
                                        backgroundColor: containerBackground,
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
                                      child: FinancialCardWidgets
                                          .buildFinancialCard(
                                        icon: Icons.trending_down,
                                        title: 'Despesa',
                                        value: CurrencyConverter.format(
                                            totalAnnualExpenses),
                                        valueStyle: TextStyle(
                                          fontSize: 14,
                                          color: expenseColor,
                                        ),
                                        withShadow: false,
                                        backgroundColor: containerBackground,
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
                      builder: (context) => const UpcomingEventsScreen(),
                    ),
                  );
                },
                child: FinancialCardWidgets.buildFinanceSectionCard(
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
      ),
    );
  }
}
