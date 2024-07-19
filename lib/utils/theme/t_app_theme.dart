import 'package:churchapp/utils/theme/elevated_button_theme.dart';
import 'package:churchapp/utils/theme/outined_button_theme.dart';
import 'package:churchapp/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class TAppTheme {
  TAppTheme._();

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: TTextTheme.lightTextTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: TTextTheme.darkTextTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
}

class TTextTheme {
  static const TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(color: Colors.black, fontSize: 32),
    bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
    bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
    // Add other text styles as needed
  );

  static const TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(color: Colors.white, fontSize: 32),
    bodyLarge: TextStyle(color: Colors.white70, fontSize: 16),
    bodyMedium: TextStyle(color: Colors.white54, fontSize: 14),
    // Add other text styles as needed
  );
}

class TAppBarTheme {
  static const AppBarTheme lightAppBarTheme = AppBarTheme(
    color: Colors.blue,
    iconTheme: IconThemeData(color: Colors.white),
    toolbarTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  );

  static const AppBarTheme darkAppBarTheme = AppBarTheme(
    color: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
    toolbarTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  );
}
