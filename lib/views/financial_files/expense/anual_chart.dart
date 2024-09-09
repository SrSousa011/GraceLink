import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

const Color generalExpensesColor = Colors.red;
const Color expensesColor = Colors.red;
const Color salariesColor = Colors.blue;
const Color maintenanceColor = Colors.orange;
const Color servicesColor = Colors.green;
const Color totalColor = Colors.purple;

const Color annualSalariesColor = Colors.blue;
const Color annualMaintenanceColor = Colors.orange;
const Color annualServicesExpensesColor = Colors.green;

class AnnualExpenseChart extends StatelessWidget {
  final double annualUtilities;
  final double totalAnnualSalaries;
  final double totalAnnualMaintenance;
  final double annualOtherExpenses;
  final double totalAnnualExpenses;
  final bool isDarkMode;

  const AnnualExpenseChart({
    super.key,
    required this.annualUtilities,
    required this.totalAnnualSalaries,
    required this.totalAnnualMaintenance,
    required this.annualOtherExpenses,
    required this.totalAnnualExpenses,
    required this.isDarkMode,
  });

  double safeValue(double? value) => value?.isFinite == true ? value! : 0;

  @override
  Widget build(BuildContext context) {
    final safeAnnualUtilities = safeValue(annualUtilities);
    final safeAnnualSalaries = safeValue(totalAnnualSalaries);
    final safeAnnualMaintenance = safeValue(totalAnnualMaintenance);
    final safeAnnualOtherExpenses = safeValue(annualOtherExpenses);
    final safeTotalAnnualExpenses = safeValue(totalAnnualExpenses);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Despesas Anuais',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 240,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: safeAnnualUtilities,
                  color: generalExpensesColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeAnnualSalaries,
                  color: annualSalariesColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeAnnualMaintenance,
                  color: annualMaintenanceColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeAnnualOtherExpenses,
                  color: annualServicesExpensesColor,
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
                _buildLegendItem('Despesas Gerais', safeAnnualUtilities,
                    generalExpensesColor, isDarkMode),
                _buildLegendItem('Salários', safeAnnualSalaries,
                    annualSalariesColor, isDarkMode),
                _buildLegendItem('Manutenção', safeAnnualMaintenance,
                    annualMaintenanceColor, isDarkMode),
                _buildLegendItem('Serviços', safeAnnualOtherExpenses,
                    annualServicesExpensesColor, isDarkMode),
                _buildLegendItem(
                    'Total', safeTotalAnnualExpenses, totalColor, isDarkMode),
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
