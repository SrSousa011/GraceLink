import 'package:flutter/material.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String tooltip;
  final IconData icon;

  const FloatingActionButtonWidget({
    Key? key,
    required this.onPressed,
    required this.tooltip,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      child: Icon(icon),
    );
  }
}