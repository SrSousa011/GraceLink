import 'package:churchapp/views/financial_files/dashboard/currency_convert.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyFinancialChart extends StatelessWidget {
  final double totalMonthlyExpenses;
  final double totalMonthlyIncome;
  final bool isDarkMode;

  const MonthlyFinancialChart({
    super.key,
    required this.totalMonthlyExpenses,
    required this.totalMonthlyIncome,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final safeTotalMonthlyExpenses =
        totalMonthlyExpenses.isFinite ? totalMonthlyExpenses : 0.0;
    final safeTotalMonthlyIncome =
        totalMonthlyIncome.isFinite ? totalMonthlyIncome : 0.0;

    const Color expensesColor = Colors.red;
    const Color incomeColor = Colors.green;

    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          SizedBox(
            height: 240,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: safeTotalMonthlyExpenses,
                    color: expensesColor,
                    title: safeTotalMonthlyExpenses > 0
                        ? CurrencyConverter.format(safeTotalMonthlyExpenses)
                        : '',
                    titleStyle: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    radius: 60,
                  ),
                  PieChartSectionData(
                    value: safeTotalMonthlyIncome,
                    color: incomeColor,
                    title: safeTotalMonthlyIncome > 0
                        ? CurrencyConverter.format(safeTotalMonthlyIncome)
                        : '',
                    titleStyle: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    radius: 60,
                  ),
                ],
                borderData: FlBorderData(show: false),
                centerSpaceRadius: 50,
                sectionsSpace: 0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                _buildLegendItem(
                  'Despesas Mensais',
                  safeTotalMonthlyExpenses,
                  expensesColor,
                  isDarkMode,
                ),
                const SizedBox(height: 8),
                _buildLegendItem(
                  'Renda Mensal',
                  safeTotalMonthlyIncome,
                  incomeColor,
                  isDarkMode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    String title,
    double value,
    Color color,
    bool isDarkMode,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                '$title: ${CurrencyConverter.format(value)}',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
