import 'package:churchapp/views/user_Profile/editProfile/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

const Color tPrimaryColor = Colors.blue;
const Color tDarkColor = Color.fromARGB(255, 255, 255, 255);

class ChangePasswordScreen extends StatelessWidget {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  ChangePasswordScreen({super.key});

  void _changePassword(BuildContext context) async {
    String currentPassword = _currentPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New Password and confirmation Password do not match'),
        ),
      );
      return;
    }

    try {
      bool isCurrentPasswordValid =
          await AuthenticationService().verifyCurrentPassword(currentPassword);

      if (!isCurrentPasswordValid) {
        const SnackBar(
          content: Text('Current Password is incorrect'),
        );
        return;
      }

      await AuthenticationService()
          .changePasswordWithConfirmation(currentPassword, newPassword);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change Password: $e')),
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
              controller: _currentPasswordController,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                prefixIcon: Icon(LineAwesomeIcons.lock_solid),
              ),
              obscureText: true,
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(LineAwesomeIcons.lock_solid),
              ),
              obscureText: true,
            ),
            const SizedBox(height: tFormHeight - 20),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                prefixIcon: Icon(LineAwesomeIcons.lock_solid),
              ),
              obscureText: true,
            ),
            const SizedBox(height: tFormHeight - 20),
            const SizedBox(height: tFormHeight),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _changePassword(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tPrimaryColor,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'Change Password',
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
