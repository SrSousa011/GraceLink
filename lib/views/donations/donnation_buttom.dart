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
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            const Color(0xFF18A0FB), // Define a cor de fundo como 18A0FB
        minimumSize:
            const Size.fromHeight(60), // Define a altura mínima do botão
        padding:
            const EdgeInsets.all(20), // Define o preenchimento interno do botão
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Define a borda arredondada
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white), // Define a cor do texto como branco
      ),
    );
  }
}
