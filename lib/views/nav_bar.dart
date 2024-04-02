import 'package:churchapp/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/views/user_profile.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

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
    super.key,
    required this.title,
    required this.icon,
    required this.route,
  });

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
  final BaseAuth auth;

  const NavBar({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeaderWidget(),
          const DrawerMenuItem(
            title: 'Home',
            icon: Icons.home_outlined,
            route: '/home',
          ),
          const DrawerMenuItem(
            title: 'User Profile',
            icon: Icons.person_outlined,
            route: '/user_profile',
          ),
          const DrawerMenuItem(
            title: 'Events',
            icon: Icons.event,
            route: '/event_page',
          ),
          const DrawerMenuItem(
            title: 'Donations',
            icon: Icons.volunteer_activism_outlined,
            route: '/donations',
          ),
          const DrawerMenuItem(
            title: 'Courses',
            icon: Icons.school_outlined,
            route: '/courses',
          ),
          const DrawerMenuItem(
            title: 'Become member',
            icon: Icons.group_add_outlined,
            route: '/become_member',
          ),
          const DrawerMenuItem(
            title: 'Notifications',
            icon: Icons.notifications_outlined,
            route: '/notifications',
          ),
          const DrawerMenuItem(
            title: 'Videos',
            icon: Icons.video_library_outlined,
            route: '/videos',
          ),
          const DrawerMenuItem(
            title: 'About Us',
            icon: Icons.info_outlined,
            route: '/about_us',
          ),
          ListTile(
            leading: const Icon(Icons.logout), // Icon for Logout
            title: const Text('Logout'),
            onTap: () {
              _handleSignOut(context); // Correctly call _handleSignOut method
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      await auth.signOut(); // Call signOut method
      // Navigate to the login screen or perform any other action after signing out
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
      // Handle sign-out error
    }
  }
}
