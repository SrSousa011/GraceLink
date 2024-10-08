import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DonationLineChart extends StatelessWidget {
  final Map<String, double> monthlyDonations;

  const DonationLineChart({super.key, required this.monthlyDonations});

  List<FlSpot> _createChartData() {
    return monthlyDonations.entries.map((entry) {
      return FlSpot(
        monthlyDonations.keys.toList().indexOf(entry.key).toDouble(),
        entry.value,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: (value, meta) {
                  const monthNames = [
                    'January',
                    'February',
                    'March',
                    'April',
                    'May',
                    'June',
                    'July',
                    'August',
                    'September',
                    'October',
                    'November',
                    'December'
                  ];
                  return Text(monthNames[value.toInt()]);
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: _createChartData(),
              isCurved: true,
              color: const Color(0xFF90EE90),
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
