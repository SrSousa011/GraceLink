import 'package:flutter/material.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/theme/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:churchapp/views/user_Profile/user_profile.dart';

class NavBar extends StatelessWidget {
  final BaseAuth auth;
  final AuthenticationService authService;
  final VoidCallback? notLoggedIn; // Callback can be null
  final String? fullName; // Added fullName parameter

  final FirebaseAuth _auth = FirebaseAuth.instance;

  NavBar({
    super.key,
    required this.auth,
    required this.authService,
    this.notLoggedIn,
    this.fullName, // Initialize fullName in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeaderWidget(
            fullName: fullName,
          ),
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
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await _auth.signOut();
              if (!context.mounted) return;
              Navigator.pop(context); // Close the drawer after logout
              // Navigate to the login screen and remove all previous routes
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Welcome(
                      title: '',
                      onSignedIn: () {},
                    );
                  },
                ),
                (route) =>
                    false, // Remove all routes except the newly pushed route
              );
            },
          ),
        ],
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
        Navigator.pop(context); // Close the drawer before navigating
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}

class DrawerHeaderWidget extends StatelessWidget {
  final String? fullName;

  const DrawerHeaderWidget({
    super.key,
    required this.fullName,
  });

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
            Navigator.pop(context); // Close the drawer before navigating
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserProfile()),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 72,
                backgroundImage:
                    AssetImage('assets/imagens/profile_picture.jpg'),
              ),
              const SizedBox(height: 12),
              Text(
                fullName ?? 'Loading...',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
