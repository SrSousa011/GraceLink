import 'package:churchapp/data/model/user_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/views/welcome.dart';
import 'package:churchapp/views/nav_bar/drawer_header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  final VoidCallback? onNotLoggedIn;

  const NavBar({super.key, this.onNotLoggedIn});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  UserData? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      if (mounted) {
        setState(() {
          userData = UserData(
            id: '',
            fullName: 'Unknown',
            address: '',
            imagePath: '',
            role: 'user',
          );
        });
      }
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (mounted) {
        setState(() {
          userData = userDoc.exists
              ? UserData.fromDocument(userDoc)
              : UserData(
                  id: userId,
                  fullName: 'Unknown',
                  address: '',
                  imagePath: '',
                  role: 'user',
                );
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          userData = UserData(
            id: userId,
            fullName: 'Error loading user',
            address: '',
            imagePath: '',
            role: 'user',
          );
        });
      }
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
    await FirebaseAuth.instance.signOut();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => Welcome(
            title: '',
            onSignedIn: () {},
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final Color iconColor = isDarkMode ? Colors.white : Colors.black;
    final Color tileColor = isDarkMode ? Colors.black : Colors.white;

    return Drawer(
      backgroundColor: tileColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeaderWidget(),
          _buildListTile(
            icon: Icons.home_outlined,
            text: 'Home',
            color: iconColor,
            onTap: () => Navigator.pushNamed(context, '/home'),
          ),
          _buildListTile(
            icon: Icons.event,
            text: 'Events',
            color: iconColor,
            onTap: () => Navigator.pushNamed(context, '/event_page'),
          ),
          _buildListTile(
            icon: Icons.volunteer_activism_outlined,
            text: 'Donations',
            color: iconColor,
            onTap: () {
              final route = userData?.role == 'admin'
                  ? '/donations_dashboard'
                  : '/donations';
              Navigator.pushNamed(context, route);
            },
          ),
          _buildListTile(
            icon: Icons.school_outlined,
            text: 'Courses',
            color: iconColor,
            onTap: () {
              final route =
                  userData?.role == 'admin' ? '/courses_dashboard' : '/courses';
              Navigator.pushNamed(context, route);
            },
          ),
          _buildListTile(
            icon: Icons.group_add_outlined,
            text: 'Become Member',
            color: iconColor,
            onTap: () {
              final route = userData?.role == 'admin'
                  ? '/members_dashboard'
                  : '/become_member';
              Navigator.pushNamed(context, route);
            },
          ),
          _buildListTile(
            icon: Icons.notifications_outlined,
            text: 'Notifications',
            color: iconColor,
            onTap: () => Navigator.pushNamed(context, '/notifications'),
          ),
          _buildListTile(
            icon: Icons.video_library_outlined,
            text: 'Videos',
            color: iconColor,
            onTap: () => Navigator.pushNamed(context, '/videos'),
          ),
          _buildListTile(
            icon: Icons.info_outlined,
            text: 'About Us',
            color: iconColor,
            onTap: () => Navigator.pushNamed(context, '/about_us'),
          ),
          if (userData?.role == 'admin')
            _buildListTile(
              icon: Icons.admin_panel_settings,
              text: 'Admin Panel',
              color: iconColor,
              onTap: () => Navigator.pushNamed(context, '/admin_panel'),
            ),
          _buildListTile(
            icon: Icons.logout,
            text: 'Logout',
            color: Colors.red,
            onTap: () => _logout(),
          ),
        ],
      ),
    );
  }

  ListTile _buildListTile({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }
}
