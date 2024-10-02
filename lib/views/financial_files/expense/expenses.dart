import 'package:churchapp/views/financial_files/expense/chart_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/financial_files/expense/expenses_service.dart';
import 'package:churchapp/views/financial_files/expense/anual_chart.dart';
import 'package:churchapp/views/financial_files/expense/monthly_chart.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final ExpensesService _expenseService = ExpensesService();

  double totalGeneralExpenses = 0.0;
  double totalSalaries = 0.0;
  double totalMaintenance = 0.0;
  double totalServices = 0.0;
  double totalAnnualExpenses = 0.0;

  double monthlyGeneralExpenses = 0.0;
  double monthlySalaries = 0.0;
  double monthlyMaintenance = 0.0;
  double monthlyServices = 0.0;
  double totalMonthlyExpenses = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchAllExpenses();
  }

  Future<void> _fetchAllExpenses() async {
    try {
      final currentDate = DateTime.now();

      final annualExpensesData = await _expenseService.fetchAnnualExpenses(
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

      final monthlyExpensesData = await _expenseService.fetchMonthlyExpenses(
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    ExpenseChartColors.isDarkMode = isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses Overview'),
        backgroundColor: ExpenseChartColors.expensesColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MonthlyExpensesChart(
                monthlyGeneralExpenses: monthlyGeneralExpenses,
                monthlySalaries: monthlySalaries,
                monthlyMaintenance: monthlyMaintenance,
                monthlyServices: monthlyServices,
                totalMonthlyExpenses: totalMonthlyExpenses,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 40),
              AnnualExpenseChart(
                annualGeneralExpenses: totalGeneralExpenses,
                annualSalaries: totalSalaries,
                annualMaintenance: totalMaintenance,
                annualServices: totalServices,
                totalAnnualExpenses: totalAnnualExpenses,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
