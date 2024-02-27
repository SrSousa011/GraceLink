import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  Widget buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0), // Adjust the padding as needed
      child: DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(
                context); // Close the drawer when the header is tapped
          },
          child: const Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }

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
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildHeader(context),
          buildMenuItem('Home', Icons.home_outlined, '/Home', context),
          buildMenuItem(
              'User Profile', Icons.person_outlined, '/UserProfile', context),
          buildMenuItem('Events', Icons.event, '/EventPage', context),
          buildMenuItem('Donations', Icons.volunteer_activism_outlined,
              '/donations', context),
          buildMenuItem('Courses', Icons.school_outlined, '/courses', context),
          buildMenuItem('Devenir membre', Icons.group_add_outlined,
              '/devenir_membre', context),
          buildMenuItem(
              'Videos', Icons.video_library_outlined, '/videos', context),
          buildMenuItem('About Us', Icons.info_outlined, '/about_us', context),
        ],
      ),
    );
  }
}
