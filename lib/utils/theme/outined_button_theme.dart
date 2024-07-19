import 'package:flutter/material.dart';

class TOutlinedButtonTheme {
  static final OutlinedButtonThemeData lightOutlinedButtonTheme =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.blue,
      textStyle: const TextStyle(fontSize: 16),
    ),
  );

  static final OutlinedButtonThemeData darkOutlinedButtonTheme =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 16),
    ),
  );
}
