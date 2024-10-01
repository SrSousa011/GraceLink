import 'package:churchapp/views/financial_files/expense/expense_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/financial_files/expense/expenses_service.dart';
import 'package:churchapp/views/financial_files/expense/anual_chart.dart';
import 'package:churchapp/views/financial_files/expense/monthly_chart.dart';

const Color generalExpensesColor = Colors.red;
const Color expensesColor = Colors.red;
const Color salariesColor = Colors.blue;
const Color maintenanceColor = Colors.orange;
const Color servicesColor = Colors.green;
const Color totalColor = Colors.purple;

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final ExpensesService _expensesService = ExpensesService();
  ExpenseData? _expenseData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    fetchExpenseData();
  }

  Future<void> fetchExpenseData() async {
    try {
      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      final endOfYear =
          DateTime(now.year + 1, 1, 1).subtract(const Duration(days: 1));

      _expenseData = await _expensesService.fetchData(startOfYear, endOfYear);
      if (kDebugMode) {
        print(
            'Total de Despesas: €${_expenseData!.totalExpenses.toStringAsFixed(2)}');
      }
      if (kDebugMode) {
        print('Despesas Mensais: ${_expenseData!.expensesPerMonth}');
      }
    } catch (error) {
      _errorMessage = error.toString();
      if (kDebugMode) {
        print('Erro ao buscar dados de despesas: $_errorMessage');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas Overview'),
        backgroundColor: expensesColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Erro: $_errorMessage'))
              : _expenseData == null
                  ? const Center(child: Text('Nenhuma despesa encontrada.'))
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MonthlyExpensesChart(
                              monthlyGeneralExpenses:
                                  _expenseData!.expensesPerMonth[
                                          'totalGeneralExpenses'] ??
                                      0.0,
                              monthlySalaries: _expenseData!
                                      .expensesPerMonth['totalSalaries'] ??
                                  0.0,
                              monthlyMaintenance: _expenseData!
                                      .expensesPerMonth['totalMaintenance'] ??
                                  0.0,
                              monthlyServices: _expenseData!
                                      .expensesPerMonth['totalServices'] ??
                                  0.0,
                              totalMonthlyExpenses: _expenseData!.totalExpenses,
                              isDarkMode: isDarkMode,
                            ),
                            const SizedBox(height: 40),
                            AnnualExpenseChart(
                              annualUtilities: _expenseData!
                                  .expensesPerMonth.values
                                  .reduce((a, b) => a + b),
                              totalAnnualSalaries: _expenseData!
                                      .expensesPerMonth['totalSalaries'] ??
                                  0.0,
                              totalAnnualMaintenance: _expenseData!
                                      .expensesPerMonth['totalMaintenance'] ??
                                  0.0,
                              annualOtherExpenses: _expenseData!
                                      .expensesPerMonth['totalServices'] ??
                                  0.0,
                              totalAnnualExpenses: _expenseData!.totalExpenses,
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ),
                      ),
                    ),
    );
  }
}
