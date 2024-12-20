import 'package:churchapp/views/financial_files/dashboard/currency_convert.dart';
import 'package:churchapp/views/financial_files/income/chart_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyIncomeChart extends StatelessWidget {
  final double totalMonthlyDonations;
  final double totalMonthlyCourses;
  final double totalMonthlyOthers;
  final double totalMonthlyReceita;
  final bool isDarkMode;

  const MonthlyIncomeChart({
    super.key,
    required this.totalMonthlyDonations,
    required this.totalMonthlyCourses,
    required this.totalMonthlyOthers,
    required this.totalMonthlyReceita,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final safeTotalMonthlyIncome =
        totalMonthlyOthers.isFinite ? totalMonthlyOthers : 0.0;
    final safeTotalMonthlyCourseRevenue =
        totalMonthlyCourses.isFinite ? totalMonthlyCourses : 0.0;
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
                  color: IncomeChartColors.kDonationColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalMonthlyCourseRevenue,
                  color: IncomeChartColors.kCourseColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalMonthlyIncome,
                  color: IncomeChartColors.kIncomeColor,
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
                    IncomeChartColors.kDonationColor, isDarkMode),
                _buildLegendItem('Cursos', safeTotalMonthlyCourseRevenue,
                    IncomeChartColors.kCourseColor, isDarkMode),
                _buildLegendItem('Outros', safeTotalMonthlyIncome,
                    IncomeChartColors.kIncomeColor, isDarkMode),
                _buildLegendItem('Total', safeTotalMonthlyReceita,
                    IncomeChartColors.kTotalColor, isDarkMode),
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
