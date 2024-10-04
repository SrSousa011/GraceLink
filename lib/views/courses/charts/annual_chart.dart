import 'package:churchapp/theme/chart_colors.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/financial_files/currency_convert.dart';
import 'package:fl_chart/fl_chart.dart';

class AnnualCoursesChart extends StatelessWidget {
  final double annualCasadosParaSempre;
  final double annualCursoDiscipulado;
  final double annualCursosParaNoivos;
  final double annualEstudoBiblico;
  final double annualHomenAoMaximo;
  final double annualMulherUnica;
  final double annualTotalIncome;
  final bool isDarkMode;

  const AnnualCoursesChart({
    super.key,
    required this.annualCasadosParaSempre,
    required this.annualCursoDiscipulado,
    required this.annualCursosParaNoivos,
    required this.annualEstudoBiblico,
    required this.annualHomenAoMaximo,
    required this.annualMulherUnica,
    required this.annualTotalIncome,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final safeMonthlyCasadosParaSempre =
        annualCasadosParaSempre.isFinite ? annualCasadosParaSempre : 0.0;
    final safeMonthlyCursoDiscipulado =
        annualCursoDiscipulado.isFinite ? annualCursoDiscipulado : 0.0;
    final safeMonthlyCursosParaNoivos =
        annualCursosParaNoivos.isFinite ? annualCursosParaNoivos : 0.0;
    final safeMonthlyEstudoBiblico =
        annualEstudoBiblico.isFinite ? annualEstudoBiblico : 0.0;
    final safeMonthlyHomenAoMaximo =
        annualHomenAoMaximo.isFinite ? annualHomenAoMaximo : 0.0;
    final safeMonthlyMulherUnica =
        annualMulherUnica.isFinite ? annualMulherUnica : 0.0;

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
                  value: safeMonthlyCasadosParaSempre,
                  color: ChartColors.casadosParaSempre,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14, color: ChartColors.themeTextColor),
                ),
                PieChartSectionData(
                  value: safeMonthlyCursoDiscipulado,
                  color: ChartColors.cursoDiscipulado,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14, color: ChartColors.themeTextColor),
                ),
                PieChartSectionData(
                  value: safeMonthlyCursosParaNoivos,
                  color: ChartColors.cursosParaNoivos,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14, color: ChartColors.themeTextColor),
                ),
                PieChartSectionData(
                  value: safeMonthlyEstudoBiblico,
                  color: ChartColors.estudoBiblico,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14, color: ChartColors.themeTextColor),
                ),
                PieChartSectionData(
                  value: safeMonthlyHomenAoMaximo,
                  color: ChartColors.homenAoMaximo,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14, color: ChartColors.themeTextColor),
                ),
                PieChartSectionData(
                  value: safeMonthlyMulherUnica,
                  color: ChartColors.mulherUnica,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14, color: ChartColors.themeTextColor),
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
                    'Casados para Sempre',
                    safeMonthlyCasadosParaSempre,
                    ChartColors.casadosParaSempre,
                    isDarkMode),
                _buildLegendItem('Discipulado', safeMonthlyCursoDiscipulado,
                    ChartColors.cursoDiscipulado, isDarkMode),
                _buildLegendItem(
                    'Cursos para Noivos',
                    safeMonthlyCursosParaNoivos,
                    ChartColors.cursosParaNoivos,
                    isDarkMode),
                _buildLegendItem('Estudo Bíblico', safeMonthlyEstudoBiblico,
                    ChartColors.estudoBiblico, isDarkMode),
                _buildLegendItem('Homem ao Máximo', safeMonthlyHomenAoMaximo,
                    ChartColors.homenAoMaximo, isDarkMode),
                _buildLegendItem('Mulher Única', safeMonthlyMulherUnica,
                    ChartColors.mulherUnica, isDarkMode),
                _buildLegendItem(
                    'Total', annualTotalIncome, ChartColors.total, isDarkMode),
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
          style: TextStyle(color: ChartColors.themeTextColor),
        ),
      ],
    );
  }
}
