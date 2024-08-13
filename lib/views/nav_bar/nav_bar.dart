import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:churchapp/views/welcome.dart';
import 'package:churchapp/views/nav_bar/drawer_header_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatelessWidget {
  final VoidCallback? notLoggedIn;

  const NavBar({super.key, this.notLoggedIn});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
    await FirebaseAuth.instance.signOut();

    if (!Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => Welcome(
          title: '',
          onSignedIn: () {},
        ),
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
            onTap: () => Navigator.pushNamed(context, '/donations'),
          ),
          _buildListTile(
            icon: Icons.school_outlined,
            text: 'Courses',
            color: iconColor,
            onTap: () => Navigator.pushNamed(context, '/courses'),
          ),
          _buildListTile(
            icon: Icons.group_add_outlined,
            text: 'Become Member',
            color: iconColor,
            onTap: () => Navigator.pushNamed(context, '/become_member'),
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
          _buildListTile(
            icon: Icons.logout,
            text: 'Logout',
            color: Colors.red,
            onTap: () => _logout(context),
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
