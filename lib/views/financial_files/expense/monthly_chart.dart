import 'package:churchapp/views/financial_files/expense/expenses.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyExpensesChart extends StatelessWidget {
  final double totalGeneralExpenses;
  final double totalSalaries;
  final double totalMaintenance;
  final double totalServices;
  final double totalMonthlyExpenses;
  final bool isDarkMode;

  const MonthlyExpensesChart({
    super.key,
    required this.totalGeneralExpenses,
    required this.totalSalaries,
    required this.totalMaintenance,
    required this.totalServices,
    required this.totalMonthlyExpenses,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final safeTotalGeneralExpenses =
        totalGeneralExpenses.isFinite ? totalGeneralExpenses : 0.0;
    final safeTotalSalaries = totalSalaries.isFinite ? totalSalaries : 0.0;
    final safeTotalMaintenance =
        totalMaintenance.isFinite ? totalMaintenance : 0.0;
    final safeTotalServices = totalServices.isFinite ? totalServices : 0.0;

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
                  value: safeTotalGeneralExpenses,
                  color: generalExpensesColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalSalaries,
                  color: salariesColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalMaintenance,
                  color: maintenanceColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalServices,
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
                _buildLegendItem('Despesas Gerais', safeTotalGeneralExpenses,
                    generalExpensesColor, isDarkMode),
                _buildLegendItem(
                    'Salários', safeTotalSalaries, salariesColor, isDarkMode),
                _buildLegendItem('Manutenção', safeTotalMaintenance,
                    maintenanceColor, isDarkMode),
                _buildLegendItem(
                    'Serviços', safeTotalServices, servicesColor, isDarkMode),
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
          '$title: € ${value.toStringAsFixed(2)}',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}
