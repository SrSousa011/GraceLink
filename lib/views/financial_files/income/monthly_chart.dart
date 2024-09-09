import 'package:churchapp/views/financial_files/currency_convert.dart';
import 'package:churchapp/views/financial_files/income/incomes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyIncomeChart extends StatelessWidget {
  final double totalMonthlyDonations;
  final double totalMonthlyCourseRevenue;
  final double totalMonthlyIncome;
  final double totalMonthlyReceita;
  final bool isDarkMode;

  const MonthlyIncomeChart({
    super.key,
    required this.totalMonthlyDonations,
    required this.totalMonthlyCourseRevenue,
    required this.totalMonthlyIncome,
    required this.totalMonthlyReceita,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final safeTotalMonthlyIncome =
        totalMonthlyIncome.isFinite ? totalMonthlyIncome : 0.0;
    final safeTotalMonthlyCourseRevenue =
        totalMonthlyCourseRevenue.isFinite ? totalMonthlyCourseRevenue : 0.0;
    final safeTotalMonthlyDonations =
        totalMonthlyDonations.isFinite ? totalMonthlyDonations : 0.0;
    final safeTotalMonthlyReceita =
        totalMonthlyReceita.isFinite ? totalMonthlyReceita : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Receita Mensal',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 240,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: safeTotalMonthlyDonations,
                  color: kDonationColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalMonthlyCourseRevenue,
                  color: kCourseColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalMonthlyIncome,
                  color: kIncomeColor,
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
                _buildLegendItem('Doações', safeTotalMonthlyDonations,
                    kDonationColor, isDarkMode),
                _buildLegendItem('Cursos', safeTotalMonthlyCourseRevenue,
                    kCourseColor, isDarkMode),
                _buildLegendItem(
                    'Outros', safeTotalMonthlyIncome, kIncomeColor, isDarkMode),
                _buildLegendItem(
                    'Total', safeTotalMonthlyReceita, kTotalColor, isDarkMode),
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
