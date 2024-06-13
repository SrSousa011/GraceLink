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
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AvatarSection(
                fullName: fullName,
                location: 'New York, USA',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
