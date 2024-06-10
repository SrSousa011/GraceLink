import 'package:flutter/material.dart';

class SnackBarUtil {
  static void displaySnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    if (context.findRenderObject()!.attached) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
    }
  }
}
