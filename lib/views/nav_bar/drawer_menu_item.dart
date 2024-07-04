import 'package:churchapp/views/user_Profile/user_profile.dart';
import 'package:flutter/material.dart';

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
              CircleAvatar(
                radius: 72,
                backgroundColor:
                    Colors.grey[200], // Cor de fundo do CircleAvatar
                child: const Icon(
                  Icons.account_circle,
                  size: 144, // Tamanho do ícone dentro do CircleAvatar
                  color: Colors.grey, // Cor do ícone
                ),
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
