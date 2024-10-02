import 'package:flutter/material.dart';

class ExpenseChartColors {
  static const Color generalExpensesColor = Colors.red;
  static const Color expensesColor = Colors.red;
  static const Color salariesColor = Colors.blue;
  static const Color maintenanceColor = Colors.orange;
  static const Color servicesColor = Colors.green;
  static const Color totalColor = Colors.purple;

  static bool isDarkMode = false;

  static Color get themeTextColor => isDarkMode ? Colors.white : Colors.black;

  static void toggleDarkMode() {
    isDarkMode = !isDarkMode;
  }
}
