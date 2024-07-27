import 'package:churchapp/models/user_data.dart';
import 'package:churchapp/views/nav_bar/drawer_header_widget.dart';
import 'package:churchapp/views/nav_bar/drawer_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/services/auth_service.dart';
import 'package:churchapp/views/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore import

class NavBar extends StatefulWidget {
  final BaseAuth auth;
  final AuthenticationService authService;
  final VoidCallback? notLoggedIn;

  const NavBar({
    super.key,
    required this.auth,
    required this.authService,
    this.notLoggedIn,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  UserData? userData;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    // Get the current user ID
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      try {
        // Fetch the user data from Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userDoc.exists) {
          setState(() {
            userData = UserData.fromDocumentSnapshot(userDoc);
          });
        } else {
          // Handle the case where user document does not exist
          setState(() {
            userData = UserData(
              id: userId,
              fullName: 'Unknown',
              address: '',
              imagePath: '',
            );
          });
        }
      } catch (e) {
        // Handle errors here
        print('Error fetching user data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeaderWidget(
            userData: userData,
          ),
          const DrawerMenuItem(
            title: 'Home',
            icon: Icons.home_outlined,
            route: '/home',
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
