import 'package:churchapp/views/donations/analyses/chart_colours.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/financial_files/currency_convert.dart';
import 'package:fl_chart/fl_chart.dart';

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
        const SizedBox(height: 8),
        SizedBox(
          height: 240,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: safeMonthlyDizimo,
                  color: DonationChartColors.dizimo,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14, color: DonationChartColors.themeTextColor),
                ),
                PieChartSectionData(
                  value: safeMonthlyOferta,
                  color: DonationChartColors.oferta,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14, color: DonationChartColors.themeTextColor),
                ),
                PieChartSectionData(
                  value: safeMonthlyProjetoDoarAAmar,
                  color: DonationChartColors.projetoDoarAAmar,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14, color: DonationChartColors.themeTextColor),
                ),
                PieChartSectionData(
                  value: safeMonthlyMissaoAfrica,
                  color: DonationChartColors.missaoAfrica,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14, color: DonationChartColors.themeTextColor),
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
                _buildLegendItem('Dizimo', safeMonthlyDizimo,
                    DonationChartColors.dizimo, isDarkMode),
                _buildLegendItem('Oferta', safeMonthlyOferta,
                    DonationChartColors.oferta, isDarkMode),
                _buildLegendItem(
                    'Projeto Doar a Amar',
                    safeMonthlyProjetoDoarAAmar,
                    DonationChartColors.projetoDoarAAmar,
                    isDarkMode),
                _buildLegendItem('Missão África', safeMonthlyMissaoAfrica,
                    DonationChartColors.missaoAfrica, isDarkMode),
                _buildLegendItem('Total', totalMonthlyDonations,
                    DonationChartColors.total, isDarkMode),
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
          style: TextStyle(color: DonationChartColors.themeTextColor),
        ),
      ],
    );
  }
}
