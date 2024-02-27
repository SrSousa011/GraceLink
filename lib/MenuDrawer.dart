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
        padding: EdgeInsets.zero,
        children: <Widget>[
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
