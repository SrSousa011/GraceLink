import 'package:flutter/material.dart';

class CoursesChartColors {
  static const Color casadosParaSempre = Colors.purple;
  static const Color cursoDiscipulado = Colors.teal;
  static const Color cursosParaNoivos = Colors.amber;
  static const Color estudoBiblico = Colors.lightBlue;
  static const Color homenAoMaximo = Colors.deepOrange;
  static const Color mulherUnica = Colors.pink;
  static const Color total = Colors.black;

  static const Color yearlyChart = Colors.green;

  static bool isDarkMode = false;

  static Color get themeTextColor => isDarkMode ? Colors.white : Colors.black;
}
