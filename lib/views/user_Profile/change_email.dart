import 'package:flutter/material.dart';
import 'package:churchapp/services/auth_service.dart';

class ChangeEmailScreen extends StatelessWidget {
  final TextEditingController _currentEmailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();

  ChangeEmailScreen({super.key});

  void _changeEmail(BuildContext context) async {
    String currentEmail = _currentEmailController.text.trim();
    String newEmail = _newEmailController.text.trim();
    String confirmEmail = _confirmEmailController.text.trim();

    if (newEmail != confirmEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('New email and confirmation email do not match')),
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
            TextFormField(
              controller: _currentEmailController,
              decoration: const InputDecoration(
                labelText: 'Current Email',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _newEmailController,
              decoration: const InputDecoration(
                labelText: 'New Email',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmEmailController,
              decoration: const InputDecoration(
                labelText: 'Confirm New Email',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _changeEmail(context),
              child: const Text('Change Email'),
            ),
          ],
        ),
      ),
    );
  }
}
