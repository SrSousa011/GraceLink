import 'package:churchapp/views/donations/charts/chart_colors.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/financial_files/dashboard/currency_convert.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthlyDonationsChart extends StatelessWidget {
  final double currentDizimo;
  final double currentOferta;
  final double currentProjetoDoarAAmar;
  final double currentMissaoAfrica;
  final double currentotalIncome;

  const MonthlyDonationsChart({
    super.key,
    required this.currentDizimo,
    required this.currentOferta,
    required this.currentProjetoDoarAAmar,
    required this.currentMissaoAfrica,
    required this.currentotalIncome,
  });

  @override
  Widget build(BuildContext context) {
    final safeMonthlyDizimo = currentDizimo.isFinite ? currentDizimo : 0.0;
    final safeMonthlyOferta = currentOferta.isFinite ? currentOferta : 0.0;
    final safeMonthlyProjetoDoarAAmar =
        currentProjetoDoarAAmar.isFinite ? currentProjetoDoarAAmar : 0.0;
    final safeMonthlyMissaoAfrica =
        currentMissaoAfrica.isFinite ? currentMissaoAfrica : 0.0;

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
                      fontSize: 14,
                      color: DonationChartColors.themeTextColor(context)),
                ),
                PieChartSectionData(
                  value: safeMonthlyOferta,
                  color: DonationChartColors.oferta,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14,
                      color: DonationChartColors.themeTextColor(context)),
                ),
                PieChartSectionData(
                  value: safeMonthlyProjetoDoarAAmar,
                  color: DonationChartColors.projetoDoarAAmar,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14,
                      color: DonationChartColors.themeTextColor(context)),
                ),
                PieChartSectionData(
                  value: safeMonthlyMissaoAfrica,
                  color: DonationChartColors.missaoAfrica,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14,
                      color: DonationChartColors.themeTextColor(context)),
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
                    DonationChartColors.dizimo, context),
                _buildLegendItem('Oferta', safeMonthlyOferta,
                    DonationChartColors.oferta, context),
                _buildLegendItem(
                    'Projeto Doar a Amar',
                    safeMonthlyProjetoDoarAAmar,
                    DonationChartColors.projetoDoarAAmar,
                    context),
                _buildLegendItem('Missão África', safeMonthlyMissaoAfrica,
                    DonationChartColors.missaoAfrica, context),
                _buildLegendItem('Total', currentotalIncome,
                    DonationChartColors.total, context),
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
    BuildContext context,
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
          style: TextStyle(color: DonationChartColors.themeTextColor(context)),
        ),
      ],
    );
  }
}
