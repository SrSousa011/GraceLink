import 'package:churchapp/views/financial_files/dashboard/currency_convert.dart';
import 'package:churchapp/views/financial_files/income/chart_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnnualIncomeChart extends StatelessWidget {
  final double totalReceita;
  final double totalOthers;
  final double totalCourses;
  final double totalDonations;
  final bool isDarkMode;

  const AnnualIncomeChart({
    super.key,
    required this.totalOthers,
    required this.totalCourses,
    required this.totalDonations,
    required this.isDarkMode,
    required this.totalReceita,
  });

  double safeValue(double? value) => value?.isFinite == true ? value! : 0;

  @override
  Widget build(BuildContext context) {
    final safeTotalIncome = safeValue(totalOthers);
    final safeTotalCourseRevenue = safeValue(totalCourses);
    final safeTotalDonations = safeValue(totalDonations);
    final safeTotalReceita = safeValue(totalReceita);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Receita Total',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 240,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: safeTotalDonations,
                  color: IncomeChartColors.kDonationColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalCourseRevenue,
                  color: IncomeChartColors.kCourseColor,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalIncome,
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
                _buildLegendItem('Doações', safeTotalDonations,
                    IncomeChartColors.kDonationColor, isDarkMode),
                _buildLegendItem('Cursos', safeTotalCourseRevenue,
                    IncomeChartColors.kCourseColor, isDarkMode),
                _buildLegendItem('Outros', safeTotalIncome,
                    IncomeChartColors.kIncomeColor, isDarkMode),
                _buildLegendItem('Total', safeTotalReceita,
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
