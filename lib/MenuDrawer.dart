import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  Widget buildMenuItem(
      String title, IconData icon, String route, BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: () {
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        children: <Widget>[
          // Home
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home_outlined),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/Home');
            },
          ),
          // User Profile
          ListTile(
            title: const Text('User Profile'),
            leading: const Icon(Icons.person_outlined),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/UserProfile');
            },
          ),
          // Events
          ListTile(
            title: const Text('Events'),
            leading: const Icon(Icons.event),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/EventPage');
            },
          ),
          // Donations
          ListTile(
            title: const Text('Donations'),
            leading: const Icon(Icons.volunteer_activism_outlined),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/donations');
            },
          ),
          // Courses
          ListTile(
            title: const Text('Courses'),
            leading: const Icon(Icons.school_outlined),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/courses');
            },
          ),
          // Devenir membre
          ListTile(
            title: const Text('Devenir membre'),
            leading: const Icon(Icons.group_add_outlined),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/devenir_membre');
            },
          ),
          // Videos
          ListTile(
            title: const Text('Videos'),
            leading: const Icon(Icons.video_library_outlined),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/videos');
            },
          ),
          // About Us
          ListTile(
            title: const Text('About Us'),
            leading: const Icon(Icons.info_outlined),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/about_us');
            },
          ),
          // Notifications
          ListTile(
            title: const Text('Notifications'),
            leading: const Icon(Icons.notifications_outlined),
            onTap: () {
              // Handle tap on Notifications menu item
            },
          ),
        ],
      ),
    );
  }
}
