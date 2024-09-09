import 'package:churchapp/views/financial_files/currency_convert.dart';
import 'package:churchapp/views/financial_files/expense/anual_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyExpensesChart extends StatelessWidget {
  final double monthlyGeneralExpenses;
  final double monthlySalaries;
  final double monthlyMaintenance;
  final double monthlyServices;
  final double totalMonthlyExpenses;
  final bool isDarkMode;

  const MonthlyExpensesChart({
    super.key,
    required this.monthlyGeneralExpenses,
    required this.monthlySalaries,
    required this.monthlyMaintenance,
    required this.monthlyServices,
    required this.totalMonthlyExpenses,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final safeMonthlyGeneralExpenses =
        monthlyGeneralExpenses.isFinite ? monthlyGeneralExpenses : 0.0;
    final safeMonthlySalaries =
        monthlySalaries.isFinite ? monthlySalaries : 0.0;
    final safeMonthlyMaintenance =
        monthlyMaintenance.isFinite ? monthlyMaintenance : 0.0;
    final safeMonthlyServices =
        monthlyServices.isFinite ? monthlyServices : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Despesas Mensais',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 240,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: safeMonthlyGeneralExpenses,
                  color: generalExpensesColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeMonthlySalaries,
                  color: salariesColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeMonthlyMaintenance,
                  color: maintenanceColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeMonthlyServices,
                  color: servicesColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
              borderData: FlBorderData(show: false),
              centerSpaceRadius: 50,
              sectionsSpace: 0,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 16.0,
              runSpacing: 8.0,
              children: [
                _buildLegendItem('Despesas Gerais', safeMonthlyGeneralExpenses,
                    generalExpensesColor, isDarkMode),
                _buildLegendItem(
                    'Salários', safeMonthlySalaries, salariesColor, isDarkMode),
                _buildLegendItem('Manutenção', safeMonthlyMaintenance,
                    maintenanceColor, isDarkMode),
                _buildLegendItem(
                    'Serviços', safeMonthlyServices, servicesColor, isDarkMode),
                _buildLegendItem(
                    'Total', totalMonthlyExpenses, totalColor, isDarkMode),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(
    String title,
    double value,
    Color color,
    bool isDarkMode,
  ) {
    return Row(
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
    );
  }
}
