import 'package:flutter/material.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:churchapp/views/user_Profile/update_profile.dart';

const Color tPrimaryColor = Colors.blue; // Example primary color
const Color tDarkColor =
    Color.fromARGB(255, 255, 255, 255); // Example dark color

class ChangeEmailScreen extends StatelessWidget {
  final TextEditingController _currentEmailController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();

  ChangeEmailScreen({super.key});

  void _changeEmail(BuildContext context) async {
    String currentEmail = _currentEmailController.text.trim();
    String newEmail = _newEmailController.text.trim();
    String confirmEmail = _confirmEmailController.text.trim();

    Color.fromARGB(255, 255, 255, 255); // Example dark color

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
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
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
            const SizedBox(height: tFormHeight),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: tPrimaryColor,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  tEditProfile,
                  style: TextStyle(color: tDarkColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
