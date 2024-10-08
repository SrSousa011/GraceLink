import 'package:flutter/material.dart';

class DonationChartColors {
  static const Color dizimo = Colors.blue;
  static const Color oferta = Colors.green;
  static const Color projetoDoarAAmar = Colors.orange;
  static const Color missaoAfrica = Colors.red;
  static const Color total = Colors.black;

  static const Color yearlyChart = Colors.green;

  static bool isDarkMode = false;

  static Color get themeTextColor => isDarkMode ? Colors.black : Colors.white;
}
