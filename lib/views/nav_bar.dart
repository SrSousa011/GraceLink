// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:churchapp/views/user_profile.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  Widget buildHeader(BuildContext context) {
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
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildHeader(context),
            ListTile(
              title: const Text('Home'),
              leading: const Icon(Icons.home_outlined),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            ListTile(
              title: const Text('User Profile'),
              leading: const Icon(Icons.person_outlined),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/user_profile');
              },
            ),
            ListTile(
              title: const Text('Events'),
              leading: const Icon(Icons.event),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/event_page');
              },
            ),
            ListTile(
              title: const Text('Donations'),
              leading: const Icon(Icons.volunteer_activism_outlined),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/donations');
              },
            ),
            ListTile(
              title: const Text('Courses'),
              leading: const Icon(Icons.school_outlined),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/courses');
              },
            ),
            ListTile(
              title: const Text('Devenir membre'),
              leading: const Icon(Icons.group_add_outlined),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/devenir_membre');
              },
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Notifications'),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle, // Define a forma como circular
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      '8',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              leading: const Icon(Icons.notifications_outlined),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/notifications');
              },
            ),
            ListTile(
              title: const Text('Videos'),
              leading: const Icon(Icons.video_library_outlined),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/videos');
              },
            ),
            ListTile(
              title: const Text('About Us'),
              leading: const Icon(Icons.info_outlined),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/about_us');
              },
            ),
          ],
        ),
      ),
    );
  }
}
