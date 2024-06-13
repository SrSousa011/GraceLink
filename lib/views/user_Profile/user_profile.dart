import 'package:churchapp/views/user_Profile/settings.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/user_Profile/avatar_section.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/nav_bar.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? fullName;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    fullName = await AuthenticationService().getCurrentUserName();
    if (mounted) {
      setState(() {});
    }
  }

  void _sendPasswordResetEmail(BuildContext context) async {
    String? email = await AuthenticationService().getCurrentUserEmail();
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
          SnackBar(content: Text('Failed to send password reset email: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      drawer: NavBar(
        auth: AuthenticationService(),
        authService: AuthenticationService(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AvatarSection(
              fullName: fullName,
              location: 'New York, USA',
            ),
          ],
        ),
      ),
    );
  }
}
