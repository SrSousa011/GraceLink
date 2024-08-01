import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/welcome.dart';
import 'package:churchapp/models/user_data.dart';
import 'package:churchapp/views/nav_bar/drawer_header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  final BaseAuth auth;
  final AuthenticationService authService;
  final VoidCallback? notLoggedIn;

  const NavBar({
    super.key,
    required this.auth,
    required this.authService,
    this.notLoggedIn,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  UserData? userData;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userDoc.exists) {
          setState(() {
            userData = UserData.fromDocument(userDoc);
          });
        } else {
          setState(() {
            userData = UserData(
              id: userId,
              fullName: 'Unknown',
              address: '',
              imagePath: '',
            );
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');

    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Welcome(
            title: '',
            onSignedIn: () {},
          );
        },
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final Color iconColor = isDarkMode ? Colors.white : Colors.black;
    final Color tileColor = isDarkMode ? Colors.black : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Drawer(
      backgroundColor: tileColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeaderWidget(
            userData: userData,
          ),
          ListTile(
            leading: Icon(Icons.home_outlined, color: iconColor),
            title: Text('Home', style: TextStyle(color: textColor)),
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.event, color: iconColor),
            title: Text('Events', style: TextStyle(color: textColor)),
            onTap: () {
              Navigator.pushNamed(context, '/event_page');
            },
          ),
          ListTile(
            leading: Icon(Icons.volunteer_activism_outlined, color: iconColor),
            title: Text('Donations', style: TextStyle(color: textColor)),
            onTap: () {
              Navigator.pushNamed(context, '/donations');
            },
          ),
          ListTile(
            leading: Icon(Icons.school_outlined, color: iconColor),
            title: Text('Courses', style: TextStyle(color: textColor)),
            onTap: () {
              Navigator.pushNamed(context, '/courses');
            },
          ),
          ListTile(
            leading: Icon(Icons.group_add_outlined, color: iconColor),
            title: Text('Become member', style: TextStyle(color: textColor)),
            onTap: () {
              Navigator.pushNamed(context, '/become_member');
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications_outlined, color: iconColor),
            title: Text('Notifications', style: TextStyle(color: textColor)),
            onTap: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          ListTile(
            leading: Icon(Icons.video_library_outlined, color: iconColor),
            title: Text('Videos', style: TextStyle(color: textColor)),
            onTap: () {
              Navigator.pushNamed(context, '/videos');
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outlined, color: iconColor),
            title: Text('About Us', style: TextStyle(color: textColor)),
            onTap: () {
              Navigator.pushNamed(context, '/about_us');
            },
          ),
          if (userData?.role == 'admin')
            ListTile(
              leading: Icon(Icons.admin_panel_settings, color: iconColor),
              title: Text('Admin Panel', style: TextStyle(color: textColor)),
              onTap: () {
                Navigator.pushNamed(context, '/admin_panel');
              },
            ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
