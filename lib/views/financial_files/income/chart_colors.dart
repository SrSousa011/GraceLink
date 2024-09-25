import 'package:flutter/material.dart';

class IncomeChartColors {
  static Color kDonationColor = const Color(0xFF4CAF50);
  static Color kCourseColor = const Color(0xFF2196F3);
  static Color kIncomeColor = const Color(0xFFFF9800);
  static Color kTotalColor = const Color(0xFF9C27B0);
  static Color kCourseRevenueColor = const Color(0xFF40C4FF);
  static Color kOtherIncomeColor = const Color(0xFFFFC107);
  static Color kTotalIncomeColor = const Color(0xFFD500F9);
  static Color kBackgroundColor = const Color(0xFFF5F5F5);
  static Color kDarkGrayColor = const Color(0xFF616161);
  static Color kDarkBlueColor = const Color(0xFF304FFE);
  static Color kDarkGreenColor = const Color(0xFF00C853);
  static Color kDarkOrangeColor = const Color(0xFFFF6D00);
  static Color kDarkPurpleColor = const Color(0xFFAA00FF);

  static bool isDarkMode = false;

  static Color get themeTextColor => isDarkMode ? Colors.white : Colors.black;
}
