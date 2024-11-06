import 'package:flutter/material.dart';

class ChartColors {
  // Courses charts
  static const Color casadosParaSempre = Colors.purple;
  static const Color cursoDiscipulado = Colors.teal;
  static const Color cursosParaNoivos = Colors.amber;
  static const Color estudoBiblico = Colors.lightBlue;
  static const Color homenAoMaximo = Colors.deepOrange;
  static const Color mulherUnica = Colors.pink;
  static const Color yearlyChart = Colors.green;

  // Cores da Home
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color eventTextColorDark = Colors.white70;
  static const Color eventTextColorLight = Colors.black;
  static const Color eventButtonColorLight = Colors.blue;
  static const Color eventButtonColorDark = Color(0xFF333333);

  static const Color backgroundDark = Color(0xFF212121);
  static const Color textDark = Colors.white70;

  static bool isDarkMode = false;
  static const Color backgroundColor = Color(0xFFEFEFEF);

  static Color get themeTextColor => isDarkMode ? Colors.white : Colors.black;
  static Color get whiteToDark => isDarkMode ? Colors.black : Colors.white;

  static Color get secondaryColor => isDarkMode ? Colors.white : Colors.grey;
  static Color get eventTextColor => isDarkMode ? Colors.white70 : Colors.black;

  static Color get churchButtonColor =>
      isDarkMode ? const Color(0xFF444444) : Colors.green;
}
