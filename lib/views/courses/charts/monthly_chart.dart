import 'package:churchapp/views/courses/charts/chart_colors.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/financial_files/currency_convert.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthlyCoursesChart extends StatelessWidget {
  final double currentCasadosParaSempre;
  final double currentCursoDiscipulado;
  final double currentCursosParaNoivos;
  final double currentEstudoBiblico;
  final double currentHomenAoMaximo;
  final double currentMulherUnica;
  final double currentTotalIncome;
  final bool isDarkMode;

  const MonthlyCoursesChart({
    super.key,
    required this.currentCasadosParaSempre,
    required this.currentCursoDiscipulado,
    required this.currentCursosParaNoivos,
    required this.currentEstudoBiblico,
    required this.currentHomenAoMaximo,
    required this.currentMulherUnica,
    required this.currentTotalIncome,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final safeMonthlyCasadosParaSempre =
        currentCasadosParaSempre.isFinite ? currentCasadosParaSempre : 0.0;
    final safeMonthlyCursoDiscipulado =
        currentCursoDiscipulado.isFinite ? currentCursoDiscipulado : 0.0;
    final safeMonthlyCursosParaNoivos =
        currentCursosParaNoivos.isFinite ? currentCursosParaNoivos : 0.0;
    final safeMonthlyEstudoBiblico =
        currentEstudoBiblico.isFinite ? currentEstudoBiblico : 0.0;
    final safeMonthlyHomenAoMaximo =
        currentHomenAoMaximo.isFinite ? currentHomenAoMaximo : 0.0;
    final safeMonthlyMulherUnica =
        currentMulherUnica.isFinite ? currentMulherUnica : 0.0;

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
                  color: CoursesChartColors.casadosParaSempre,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14, color: CoursesChartColors.themeTextColor),
                ),
                PieChartSectionData(
                  value: safeMonthlyCursoDiscipulado,
                  color: CoursesChartColors.cursoDiscipulado,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14, color: CoursesChartColors.themeTextColor),
                ),
                PieChartSectionData(
                  value: safeMonthlyCursosParaNoivos,
                  color: CoursesChartColors.cursosParaNoivos,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14, color: CoursesChartColors.themeTextColor),
                ),
                PieChartSectionData(
                  value: safeMonthlyEstudoBiblico,
                  color: CoursesChartColors.estudoBiblico,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14, color: CoursesChartColors.themeTextColor),
                ),
                PieChartSectionData(
                  value: safeMonthlyHomenAoMaximo,
                  color: CoursesChartColors.homenAoMaximo,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14, color: CoursesChartColors.themeTextColor),
                ),
                PieChartSectionData(
                  value: safeMonthlyMulherUnica,
                  color: CoursesChartColors.mulherUnica,
                  radius: 60,
                  titleStyle: TextStyle(
                      fontSize: 14, color: CoursesChartColors.themeTextColor),
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
                    CoursesChartColors.casadosParaSempre,
                    isDarkMode),
                _buildLegendItem('Discipulado', safeMonthlyCursoDiscipulado,
                    CoursesChartColors.cursoDiscipulado, isDarkMode),
                _buildLegendItem(
                    'Cursos para Noivos',
                    safeMonthlyCursosParaNoivos,
                    CoursesChartColors.cursosParaNoivos,
                    isDarkMode),
                _buildLegendItem('Estudo Bíblico', safeMonthlyEstudoBiblico,
                    CoursesChartColors.estudoBiblico, isDarkMode),
                _buildLegendItem('Homem ao Máximo', safeMonthlyHomenAoMaximo,
                    CoursesChartColors.homenAoMaximo, isDarkMode),
                _buildLegendItem('Mulher Única', safeMonthlyMulherUnica,
                    CoursesChartColors.mulherUnica, isDarkMode),
                _buildLegendItem('Total', currentTotalIncome,
                    CoursesChartColors.total, isDarkMode),
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
          style: TextStyle(color: CoursesChartColors.themeTextColor),
        ),
      ],
    );
  }
}
