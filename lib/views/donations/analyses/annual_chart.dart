import 'package:churchapp/views/donations/analyses/chart_colours.dart';
import 'package:churchapp/views/financial_files/currency_convert.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnnualDonationsChart extends StatelessWidget {
  final double totalDizimo;
  final double totalOferta;
  final double totalProjetoDoarAAmar;
  final double totalMissaoAfrica;
  final double totalAnnualDonations;
  final bool isDarkMode;

  const AnnualDonationsChart({
    super.key,
    required this.totalDizimo,
    required this.totalOferta,
    required this.totalProjetoDoarAAmar,
    required this.totalMissaoAfrica,
    required this.totalAnnualDonations,
    required this.isDarkMode,
  });

  double safeValue(double? value) => value?.isFinite == true ? value! : 0;

  @override
  Widget build(BuildContext context) {
    final safeTotalDizimo = safeValue(totalDizimo);
    final safeTotalOferta = safeValue(totalOferta);
    final safeTotalProjetoDoarAAmar = safeValue(totalProjetoDoarAAmar);
    final safeTotalMissaoAfrica = safeValue(totalMissaoAfrica);
    final safeTotalAnnualDonations = safeValue(totalAnnualDonations);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 240,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: safeTotalDizimo,
                  color: DonationChartColors.dizimo,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: DonationChartColors.themeTextColor
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalOferta,
                  color: DonationChartColors.oferta,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: DonationChartColors.themeTextColor
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalProjetoDoarAAmar,
                  color: DonationChartColors.projetoDoarAAmar,
                  radius: 60,
                  titleStyle: TextStyle(
                    fontSize: 14,
                    color: DonationChartColors.themeTextColor
                  ),
                ),
                PieChartSectionData(
                  value: safeTotalMissaoAfrica,
                  color: DonationChartColors.missaoAfrica,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14,
                      color: DonationChartColors.themeTextColor),
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
                _buildLegendItem('Dizimo', safeTotalDizimo,
                    DonationChartColors.dizimo, isDarkMode),
                _buildLegendItem('Oferta', safeTotalOferta,
                    DonationChartColors.oferta, isDarkMode),
                _buildLegendItem(
                    'Projeto Doar a Amar',
                    safeTotalProjetoDoarAAmar,
                    DonationChartColors.projetoDoarAAmar,
                    isDarkMode),
                _buildLegendItem('Missão África', safeTotalMissaoAfrica,
                    DonationChartColors.missaoAfrica, isDarkMode),
                _buildLegendItem('Total', safeTotalAnnualDonations,
                    DonationChartColors.total, isDarkMode),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(
      String title, double value, Color color, bool isDarkMode) {
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
                    color: DonationChartColors.themeTextColor
          ),
        ),
      ],
    );
  }
}
