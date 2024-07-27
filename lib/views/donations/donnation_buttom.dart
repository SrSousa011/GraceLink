import 'package:flutter/material.dart';

class DonateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const DonateButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color buttonColor = theme.brightness == Brightness.light
        ? const Color(0xFF007BFF) // Azul claro
        : Colors.grey; // Cinza no modo escuro

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(60),
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: buttonColor,
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
