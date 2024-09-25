import 'package:churchapp/views/financial_files/currency_convert.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyDonationsChart extends StatelessWidget {
  final double monthlyDizimo;
  final double monthlyOferta;
  final double monthlyProjetoDoarAAmar;
  final double monthlyMissaoAfrica;
  final double totalMonthlyDonations;
  final bool isDarkMode;

  const MonthlyDonationsChart({
    super.key,
    required this.monthlyDizimo,
    required this.monthlyOferta,
    required this.monthlyProjetoDoarAAmar,
    required this.monthlyMissaoAfrica,
    required this.totalMonthlyDonations,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final safeMonthlyDizimo = monthlyDizimo.isFinite ? monthlyDizimo : 0.0;
    final safeMonthlyOferta = monthlyOferta.isFinite ? monthlyOferta : 0.0;
    final safeMonthlyProjetoDoarAAmar =
        monthlyProjetoDoarAAmar.isFinite ? monthlyProjetoDoarAAmar : 0.0;
    final safeMonthlyMissaoAfrica =
        monthlyMissaoAfrica.isFinite ? monthlyMissaoAfrica : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Doações Mensais',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 240,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: safeMonthlyDizimo,
                  color: Colors.blue, // Replace with your color for Dizimo
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeMonthlyOferta,
                  color: Colors.green, // Replace with your color for Oferta
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeMonthlyProjetoDoarAAmar,
                  color: Colors
                      .orange, // Replace with your color for Projeto Doar a Amar
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: safeMonthlyMissaoAfrica,
                  color:
                      Colors.red, // Replace with your color for Missão África
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
                _buildLegendItem(
                    'Dizimo', safeMonthlyDizimo, Colors.blue, isDarkMode),
                _buildLegendItem(
                    'Oferta', safeMonthlyOferta, Colors.green, isDarkMode),
                _buildLegendItem('Projeto Doar a Amar',
                    safeMonthlyProjetoDoarAAmar, Colors.orange, isDarkMode),
                _buildLegendItem('Missão África', safeMonthlyMissaoAfrica,
                    Colors.red, isDarkMode),
                _buildLegendItem(
                    'Total', totalMonthlyDonations, Colors.black, isDarkMode),
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
