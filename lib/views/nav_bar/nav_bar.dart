import 'package:churchapp/views/nav_bar/drawer_header_widget.dart';
import 'package:churchapp/views/nav_bar/drawer_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/theme/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavBar extends StatefulWidget {
  final BaseAuth auth;
  final AuthenticationService authService;
  final VoidCallback? notLoggedIn;
  final String? fullName;

  const NavBar({
    super.key,
    required this.auth,
    required this.authService,
    this.notLoggedIn,
    this.fullName,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String? fullName;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    fullName = await AuthenticationService().getCurrentUserName();
    if (mounted) {
      setState(() {});
    }
  }

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
            },
          ),
        ],
      ),
    );
  }
}
