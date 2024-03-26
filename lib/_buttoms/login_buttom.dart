import 'package:flutter/material.dart';
import 'package:churchapp/views/login.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignInPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color(0xFF1E88E5),
        backgroundColor: Colors.white, // Cor do texto azul
        side: const BorderSide(color: Color(0xFF1E88E5)), // Borda azul
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: const Text('Login'),
    );
  }
}
