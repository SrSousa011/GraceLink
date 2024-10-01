import 'package:churchapp/views/courses/charts/chart_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class YearlyCourses extends StatelessWidget {
  final Map<String, double> monthlyCourses;
  final bool isDarkMode;

  const YearlyCourses({
    super.key,
    required this.monthlyCourses,
    required this.isDarkMode,
  });

  List<BarChartGroupData> _createChartData() {
    return monthlyCourses.entries.map((entry) {
      return BarChartGroupData(
        x: monthlyCourses.keys.toList().indexOf(entry.key),
        barRods: [
          BarChartRodData(
            toY: entry.value,
            color: CoursesChartColors.yearlyChart,
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: _createChartData(),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      (value.toInt() + 1).toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          backgroundColor: Colors.white.withOpacity(0.5),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(),
          ),
        ),
      ),
    );
  }
}
