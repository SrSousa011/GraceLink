import 'package:flutter/material.dart';
import 'package:churchapp/views/user_Profile/change_email.dart';
import 'package:churchapp/views/user_Profile/change_password.dart';
import 'package:churchapp/services/auth_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.email),
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
            leading: const Icon(Icons.lock),
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
            leading: const Icon(Icons.mail),
            title: const Text('Send Password Reset Email'),
            onTap: () async {
              String? email =
                  await AuthenticationService().getCurrentUserEmail();
              if (email != null) {
                try {
                  await AuthenticationService().sendPasswordResetEmail(email);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password reset email sent')),
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
    );
  }
}
