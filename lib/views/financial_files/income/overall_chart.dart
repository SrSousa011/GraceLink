import 'package:churchapp/views/financial_files/income/incomes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OverallIncomeChart extends StatelessWidget {
  final double totalOverallReceita;
  final double totalOverallSum;
  final double totalOverallCourseRevenue;
  final double totalOverallDonations;
  final bool isDarkMode;

  const OverallIncomeChart({
    super.key,
    required this.totalOverallSum,
    required this.totalOverallCourseRevenue,
    required this.totalOverallDonations,
    required this.isDarkMode,
    required this.totalOverallReceita,
  });

  double safeValue(double? value) => value?.isFinite == true ? value! : 0;

  @override
  Widget build(BuildContext context) {
    final safeTotalOverallReceita = safeValue(totalOverallReceita);
    final safeTotalOverallSum = safeValue(totalOverallSum);
    final safeTotalOverallCourseRevenue = safeValue(totalOverallCourseRevenue);
    final safeTotalOverallDonations = safeValue(totalOverallDonations);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Distribuição de Receitas Totais',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 50),
        SizedBox(
          height: 270,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              titlesData: const FlTitlesData(show: true),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: false),
              maxY: safeTotalOverallSum,
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: safeTotalOverallDonations,
                      color: kDonationColor,
                      width: 20,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: safeTotalOverallCourseRevenue,
                      color: kCourseColor,
                      width: 20,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(
                      toY: safeTotalOverallSum,
                      color: kIncomeColor,
                      width: 20,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem('Doações', safeTotalOverallDonations,
                    kDonationColor, isDarkMode),
                _buildLegendItem('Cursos', safeTotalOverallCourseRevenue,
                    kCourseColor, isDarkMode),
                _buildLegendItem(
                    'Outros', safeTotalOverallSum, kIncomeColor, isDarkMode),
                _buildLegendItem(
                    'Total', safeTotalOverallReceita, kTotalColor, isDarkMode),
              ],
            ),
          ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$title: € ${value.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
