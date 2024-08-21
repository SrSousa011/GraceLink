import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:churchapp/views/welcome.dart';
import 'package:churchapp/views/nav_bar/drawer_header_widget.dart';
import 'package:churchapp/data/model/user_data.dart';

class NavBar extends StatefulWidget {
  final VoidCallback? onNotLoggedIn;

  const NavBar({super.key, this.onNotLoggedIn});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final Color iconColor = isDarkMode ? Colors.white : Colors.black;
    final Color tileColor = isDarkMode ? Colors.black : Colors.white;

    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return _buildNotLoggedInDrawer(tileColor, iconColor);
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Drawer(
            backgroundColor: tileColor,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Drawer(
            backgroundColor: tileColor,
            child: const Center(child: Text('Error loading user data')),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Drawer(
            backgroundColor: tileColor,
            child: const Center(child: Text('User not found')),
          );
        }

        final userDoc = snapshot.data!;
        final userData = UserData.fromDocument(userDoc);

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('courseregistration')
              .where('userId', isEqualTo: userId)
              .snapshots(),
          builder: (context, courseSnapshot) {
            if (courseSnapshot.connectionState == ConnectionState.waiting) {
              return Drawer(
                backgroundColor: tileColor,
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            if (courseSnapshot.hasError) {
              return Drawer(
                backgroundColor: tileColor,
                child: const Center(child: Text('Error loading courses')),
              );
            }

            final isEnrolledInCourse =
                courseSnapshot.data?.docs.isNotEmpty ?? false;

            return Drawer(
              backgroundColor: tileColor,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeaderWidget(),
                  _buildListTile(
                    icon: Icons.home_outlined,
                    text: 'Home',
                    color: iconColor,
                    onTap: () => Navigator.pushNamed(context, '/home'),
                  ),
                  _buildListTile(
                    icon: Icons.event,
                    text: 'Eventos',
                    color: iconColor,
                    onTap: () => Navigator.pushNamed(context, '/event_page'),
                  ),
                  _buildListTile(
                    icon: Icons.volunteer_activism_outlined,
                    text: 'Doações',
                    color: iconColor,
                    onTap: () {
                      final route = userData.role == 'admin'
                          ? '/donations_dashboard'
                          : '/donations';
                      Navigator.pushNamed(context, route);
                    },
                  ),
                  _buildListTile(
                    icon: Icons.school_outlined,
                    text: 'Cursos',
                    color: iconColor,
                    onTap: () {
                      final route = userData.role == 'admin'
                          ? '/courses_dashboard'
                          : '/courses';
                      Navigator.pushNamed(context, route);
                    },
                  ),
                  if (userData.role == 'admin' || isEnrolledInCourse)
                    _buildListTile(
                      icon: Icons.upload_file_outlined,
                      text: 'Materiais de cursos',
                      color: iconColor,
                      onTap: () => Navigator.pushNamed(
                          context, '/manage_course_materials'),
                    ),
                  _buildListTile(
                    icon: Icons.group_add_outlined,
                    text: 'Torne-se Membro',
                    color: iconColor,
                    onTap: () {
                      final route = userData.role == 'admin'
                          ? '/members_dashboard'
                          : '/become_member';
                      Navigator.pushNamed(context, route);
                    },
                  ),
                  _buildListTile(
                    icon: Icons.notifications_outlined,
                    text: 'Notificações',
                    color: iconColor,
                    onTap: () => Navigator.pushNamed(context, '/notifications'),
                  ),
                  _buildListTile(
                    icon: Icons.video_library_outlined,
                    text: 'Vídeos',
                    color: iconColor,
                    onTap: () => Navigator.pushNamed(context, '/videos'),
                  ),
                  _buildListTile(
                    icon: Icons.info_outlined,
                    text: 'Sobre nós',
                    color: iconColor,
                    onTap: () => Navigator.pushNamed(context, '/about_us'),
                  ),
                  if (userData.role == 'admin')
                    _buildListTile(
                      icon: Icons.admin_panel_settings,
                      text: 'Admin Painel',
                      color: iconColor,
                      onTap: () => Navigator.pushNamed(context, '/admin_panel'),
                    ),
                  _buildListTile(
                    icon: Icons.logout,
                    text: 'Logout',
                    color: Colors.red,
                    onTap: () => _logout(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Drawer _buildNotLoggedInDrawer(Color tileColor, Color iconColor) {
    return Drawer(
      backgroundColor: tileColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeaderWidget(),
          _buildListTile(
            icon: Icons.home_outlined,
            text: 'Home',
            color: iconColor,
            onTap: () => Navigator.pushNamed(context, '/home'),
          ),
          _buildListTile(
            icon: Icons.event,
            text: 'Events',
            color: iconColor,
            onTap: () => Navigator.pushNamed(context, '/event_page'),
          ),
          _buildListTile(
            icon: Icons.volunteer_activism_outlined,
            text: 'Donations',
            color: iconColor,
            onTap: () => Navigator.pushNamed(context, '/donations'),
          ),
          _buildListTile(
            icon: Icons.group_add_outlined,
            text: 'Become Member',
            color: iconColor,
            onTap: () => Navigator.pushNamed(context, '/become_member'),
          ),
          _buildListTile(
            icon: Icons.notifications_outlined,
            text: 'Notifications',
            color: iconColor,
            onTap: () => Navigator.pushNamed(context, '/notifications'),
          ),
          _buildListTile(
            icon: Icons.video_library_outlined,
            text: 'Videos',
            color: iconColor,
            onTap: () => Navigator.pushNamed(context, '/videos'),
          ),
          _buildListTile(
            icon: Icons.info_outlined,
            text: 'About Us',
            color: iconColor,
            onTap: () => Navigator.pushNamed(context, '/about_us'),
          ),
        ],
      ),
    );
  }

  ListTile _buildListTile({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
    await FirebaseAuth.instance.signOut();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => Welcome(
            title: '',
            onSignedIn: () {},
          ),
        ),
        (route) => false,
      );
    }
  }
}
