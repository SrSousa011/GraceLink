import 'package:flutter/material.dart';

class DonateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const DonateButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Doação realizada com sucesso!'),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF18A0FB),
        minimumSize: const Size.fromHeight(60),
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
