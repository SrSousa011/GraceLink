import 'package:flutter/material.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:churchapp/views/user_Profile/update_profile.dart';

const Color tPrimaryColor = Colors.blue; // Example primary color
const Color tDarkColor =
    Color.fromARGB(255, 255, 255, 255); // Example dark color

class ChangePhoneScreen extends StatelessWidget {
  final TextEditingController _currentPhoneController = TextEditingController();
  final TextEditingController _newPhoneController = TextEditingController();
  final TextEditingController _confirmPhoneController = TextEditingController();

  ChangePhoneScreen({super.key});

  void _changePhone(BuildContext context) async {
    String currentPhone = _currentPhoneController.text.trim();
    String newPhone = _newPhoneController.text.trim();
    String confirmPhone = _confirmPhoneController.text.trim();

    if (newPhone != confirmPhone) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New phone and confirmation phone do not match'),
        ),
      );
      return;
    }

    try {
      await AuthenticationService()
          .changePhoneWithConfirmation(currentPhone, newPhone);
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
              controller: _currentPhoneController,
              decoration: const InputDecoration(
                labelText: 'Current Email',
                prefixIcon: Icon(LineAwesomeIcons.envelope),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _newPhoneController,
              decoration: const InputDecoration(
                labelText: 'New Email',
                prefixIcon: Icon(LineAwesomeIcons.envelope),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _confirmPhoneController,
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
                onPressed: () => _changePhone(context),
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
