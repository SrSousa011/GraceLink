import 'package:churchapp/services/auth_service.dart';
import 'package:flutter/material.dart';

class SignUpButton extends StatelessWidget {
  final BaseAuth auth;
  final void Function() onSignedIn;

  const SignUpButton({
    super.key,
    required this.auth,
    required this.onSignedIn,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onSignedIn(); // Chamada direta da função onSignedIn
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 90, 175, 249),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: const Text('Sign Up'),
    );
  }
}
