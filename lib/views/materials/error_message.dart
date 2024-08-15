import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;

  const ErrorMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.white70 : Colors.grey[700],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
