import 'package:flutter/material.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:churchapp/views/user_Profile/update_profile.dart';

class ChangeNameScreen extends StatelessWidget {
  final TextEditingController _currentEmailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();

  ChangeNameScreen({super.key});

  void _changeEmail(BuildContext context) async {
    String currentEmail = _currentEmailController.text.trim();
    String newEmail = _newEmailController.text.trim();
    String confirmEmail = _confirmEmailController.text.trim();

    if (newEmail != confirmEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New email and confirmation email do not match'),
        ),
      );
      return;
    }

    try {
      await AuthenticationService()
          .changeEmailWithConfirmation(currentEmail, newEmail);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email changed successfully')),
      );
      Navigator.pop(
          context); // Navigate back to UserProfile after successful change
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change email: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _currentEmailController,
              decoration: const InputDecoration(
                labelText: 'Current Email',
                prefixIcon: Icon(LineAwesomeIcons.envelope),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _newEmailController,
              decoration: const InputDecoration(
                labelText: 'New Email',
                prefixIcon: Icon(LineAwesomeIcons.envelope),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _confirmEmailController,
              decoration: const InputDecoration(
                labelText: 'Confirm New Email',
                prefixIcon: Icon(LineAwesomeIcons.envelope),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            const SizedBox(height: 16),
            SizedBox(
              height: 40, // Reduzi a altura para 40
              child: ElevatedButton(
                onPressed: () => _changeEmail(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF5AAFf9), // Cor de fundo do botão
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16.0), // Raio das bordas do botão
                  ),
                  elevation: 0, // Reduzi a elevação para 0
                ),
                child: const Text(
                  'Change Email',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white), // Estilo do texto do botão
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
