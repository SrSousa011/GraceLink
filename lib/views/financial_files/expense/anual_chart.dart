import 'package:churchapp/views/financial_files/dashboard/currency_convert.dart';
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
  final double annualGeneralExpenses;
  final double annualSalaries;
  final double annualMaintenance;
  final double annualServices;
  final double totalAnnualExpenses;
  final bool isDarkMode;

  const AnnualExpenseChart({
    super.key,
    required this.annualGeneralExpenses,
    required this.annualSalaries,
    required this.annualMaintenance,
    required this.annualServices,
    required this.totalAnnualExpenses,
    required this.isDarkMode,
  });

  double safeValue(double? value) => value?.isFinite == true ? value! : 0;

  @override
  Widget build(BuildContext context) {
    final safeAnnualUtilities = safeValue(annualGeneralExpenses);
    final safeAnnualSalaries = safeValue(annualSalaries);
    final safeAnnualMaintenance = safeValue(annualMaintenance);
    final safeAnnualServices = safeValue(annualServices);
    final safeTotalAnnualExpenses = safeValue(totalAnnualExpenses);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Despesas Totais',
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
                  value: safeAnnualServices,
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
                _buildLegendItem('Serviços', safeAnnualServices,
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
          '$title: ${CurrencyConverter.format(value)}',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}
