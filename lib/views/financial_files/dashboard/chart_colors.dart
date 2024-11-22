import 'package:flutter/material.dart';

class ChartColors {
  static bool isDarkMode = false;

  static Color get backgroundColor => isDarkMode ? Colors.black : Colors.white;
  static Color get primaryTextColor => isDarkMode ? Colors.white : Colors.black;
  static Color get cardBackgroundColor =>
      isDarkMode ? Colors.grey[800]! : Colors.white;
  static Color get cardBackOutgroundColor =>
      isDarkMode ? Colors.grey[800]! : const Color.fromARGB(255, 239, 241, 242);
  static Color get cardTextColor => isDarkMode ? Colors.white : Colors.black;
  static Color get accentColor => isDarkMode ? Colors.blueGrey : Colors.blue;
  static Color get incomeColor =>
      isDarkMode ? Colors.lightGreenAccent : Colors.lightGreen;
  static Color get expenseColor => isDarkMode ? Colors.redAccent : Colors.red;
  static Color get cardShadowColor => isDarkMode
      ? Colors.black.withOpacity(0.5)
      : Colors.black.withOpacity(0.2);

  static Color get themeTextColor => isDarkMode ? Colors.white : Colors.black;
}
