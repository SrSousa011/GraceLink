import 'package:churchapp/models/user_data.dart';
import 'package:churchapp/views/user_Profile/user_profile.dart';
import 'package:flutter/material.dart';

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
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                          userData: UserData(
                        fullName: fullName ?? '',
                        id: '',
                        address: '', imagePath: '',
                        // Add other necessary fields from UserData model
                      ))),
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