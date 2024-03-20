import 'package:flutter/material.dart';

class MySnackBar extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;

  const MySnackBar({
    super.key,
    required this.message,
    this.backgroundColor = Colors.red,
    this.icon = Icons.error,
  });

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: backgroundColor,
      content: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }
}
