import 'package:churchapp/views/user_Profile/settings/change_name.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:churchapp/views/user_Profile/settings/change_email.dart';
import 'package:churchapp/views/user_Profile/settings/change_password.dart';
import 'package:churchapp/services/auth_service.dart';

const Color tPrimaryColor = Colors.blue; // Example primary color
const Color tDarkColor = Colors.black; // Example dark color

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(LineAwesomeIcons.angle_left_solid),
        ),
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: const Icon(LineAwesomeIcons.envelope),
              title: const Text('Change Name'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeNameScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(LineAwesomeIcons.envelope),
              title: const Text('Change Email'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeEmailScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(LineAwesomeIcons.lock_solid),
              title: const Text('Change Password'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(LineAwesomeIcons.phone_alt_solid),
              title: const Text('Change Phone'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangeEmailScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(LineAwesomeIcons.envelope),
              title: const Text('Send Password Reset Email'),
              onTap: () async {
                String? email =
                    await AuthenticationService().getCurrentUserEmail();
                if (email != null) {
                  try {
                    await AuthenticationService().sendPasswordResetEmail(email);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Password reset email sent')),
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Failed to send password reset email: $e')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
