import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String text,
  bool isError = true,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor:
          isError ? Colors.red : Colors.green, // Customize color based on error
      duration: const Duration(seconds: 2),
    ),
  );
}
