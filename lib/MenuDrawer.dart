import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  Widget buildHeader(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 270, // Ajuste a altura conforme necessário
      child: DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.blue,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(
                context); // Fechar o drawer quando o cabeçalho for tocado
          },
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 72, // Ajuste o raio do avatar conforme necessário
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
                Navigator.pushReplacementNamed(context, '/Home');
              },
            ),
            ListTile(
              title: const Text('User Profile'),
              leading: const Icon(Icons.person_outlined),
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
