import 'package:flutter/material.dart';
import 'package:churchapp/views/user_profile.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 270,
      child: DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.blue,
          image: DecorationImage(
            image: AssetImage('assets/imagens/bacground-image-center.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserProfile()),
            );
          },
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 72,
                backgroundImage:
                    AssetImage('assets/imagens/profile_picture.jpg'),
              ),
              SizedBox(height: 12),
              Text(
                'Anaïs',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerMenuItem extends StatelessWidget {
  const DrawerMenuItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.route,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      onTap: () {
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DrawerHeaderWidget(),
            DrawerMenuItem(
              title: 'Home',
              icon: Icons.home_outlined,
              route: '/home',
            ),
            DrawerMenuItem(
              title: 'User Profile',
              icon: Icons.person_outlined,
              route: '/user_profile',
            ),
            DrawerMenuItem(
              title: 'Events',
              icon: Icons.event,
              route: '/event_page',
            ),
            DrawerMenuItem(
              title: 'Donations',
              icon: Icons.volunteer_activism_outlined,
              route: '/donations',
            ),
            DrawerMenuItem(
              title: 'Courses',
              icon: Icons.school_outlined,
              route: '/courses',
            ),
            DrawerMenuItem(
              title: 'Become member',
              icon: Icons.group_add_outlined,
              route: '/become_member',
            ),
            DrawerMenuItem(
              title: 'Notifications',
              icon: Icons.notifications_outlined,
              route: '/notifications',
            ),
            DrawerMenuItem(
              title: 'Videos',
              icon: Icons.video_library_outlined,
              route: '/videos',
            ),
            DrawerMenuItem(
              title: 'About Us',
              icon: Icons.info_outlined,
              route: '/about_us',
            ),
          ],
        ),
      ),
    );
  }
}
