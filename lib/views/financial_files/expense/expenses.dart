import 'package:churchapp/views/financial_files/expense/expenses_service.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/financial_files/expense/anual_chart.dart';
import 'package:churchapp/views/financial_files/expense/monthly_chart.dart';

const Color generalExpensesColor = Colors.red;
const Color expensesColor = Colors.red;
const Color salariesColor = Colors.blue;
const Color maintenanceColor = Colors.orange;
const Color servicesColor = Colors.green;
const Color totalColor = Colors.purple;

const Color annualSalariesColor = Colors.red;
const Color annualMaintenanceColor = Colors.green;
const Color annualOtherExpensesColor = Colors.orange;

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  late Future<List<Map<String, double>>> _expensesAndAnnualExpensesFuture;
  final ExpensesService _expensesService = ExpensesService();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth =
        DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1));

    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear =
        DateTime(now.year + 1, 1, 1).subtract(const Duration(days: 1));

    _expensesAndAnnualExpensesFuture = Future.wait([
      _expensesService.fetchExpenses(startOfMonth, endOfMonth),
      _expensesService.fetchAnnualExpenses(startOfYear, endOfYear),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas'),
        backgroundColor: expensesColor,
      ),
      body: FutureBuilder<List<Map<String, double>>>(
        future: _expensesAndAnnualExpensesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Nenhuma despesa encontrada.'));
          }

          final expenses = snapshot.data![0];
          final annualExpenses = snapshot.data![1];

          final monthlyGeneralExpenses =
              expenses['monthlyGeneralExpenses'] ?? 0.0;
          final monthlySalaries = expenses['monthlySalaries'] ?? 0.0;
          final monthlyMaintenance = expenses['monthlyMaintenance'] ?? 0.0;
          final monthlyServices = expenses['monthlyServices'] ?? 0.0;
          final totalMonthlyExpenses = expenses['totalMonthlyExpenses'] ?? 0.0;

          final annualUtilities = annualExpenses['annualUtilities'] ?? 0.0;
          final annualSalaries = annualExpenses['annualSalaries'] ?? 0.0;
          final annualMaintenance = annualExpenses['annualMaintenance'] ?? 0.0;
          final annualOtherExpenses =
              annualExpenses['annualOtherExpenses'] ?? 0.0;
          final totalAnnualExpenses =
              annualExpenses['totalAnnualExpenses'] ?? 0.0;

          return SingleChildScrollView(
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
                    annualUtilities: annualUtilities,
                    totalAnnualSalaries: annualSalaries,
                    totalAnnualMaintenance: annualMaintenance,
                    annualOtherExpenses: annualOtherExpenses,
                    totalAnnualExpenses: totalAnnualExpenses,
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
