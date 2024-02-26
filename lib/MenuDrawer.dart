import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/Home');
            },
          ),
          ListTile(
            title: const Text('User Profile'),
            leading: const Icon(Icons.person),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/UserProfile');
            },
          ),
          ListTile(
            title: const Text('Events'),
            leading: const Icon(Icons.event),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/EventPage');
            },
          ),
          ListTile(
            title: const Text('Donations'),
            leading: const Icon(Icons.volunteer_activism),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/donations');
            },
          ),
          ListTile(
            title: const Text('Courses'),
            leading: const Icon(Icons.school),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/courses');
            },
          ),
          ListTile(
            title: const Text('Devenir membre'),
            leading: const Icon(Icons.group_add),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/devenir_membre');
            },
          ),
          ListTile(
            title: const Text('Videos'),
            leading: const Icon(Icons.video_library),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/videos');
            },
          ),
          ListTile(
            title: const Text('About Us'),
            leading: const Icon(Icons.info),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/about_us');
            },
          ),
        ],
      ),
    );
  }
}
