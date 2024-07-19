import 'package:flutter/material.dart';

const Color tSecondaryColor = Colors.blue;
const Color tPrimaryColor = Colors.red;

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static const InputDecorationTheme lightInputDecorationTheme =
      InputDecorationTheme(
    border: OutlineInputBorder(),
    prefixIconColor: tSecondaryColor,
    floatingLabelStyle: TextStyle(color: tSecondaryColor),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: tSecondaryColor),
    ),
  );

  static const InputDecorationTheme darkInputDecorationTheme =
      InputDecorationTheme(
    border: OutlineInputBorder(),
    prefixIconColor: tPrimaryColor,
    floatingLabelStyle: TextStyle(color: tPrimaryColor),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: tPrimaryColor),
    ),
  );
}
