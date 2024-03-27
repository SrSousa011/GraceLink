import 'package:churchapp/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final BaseAuth auth;
  final void Function() onSignedIn;

  const LoginButton({
    super.key,
    required this.auth,
    required this.onSignedIn,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onSignedIn();
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
