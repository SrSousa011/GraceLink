import 'dart:io';

import 'package:churchapp/models/user_data.dart';
import 'package:churchapp/views/user_Profile/user_profile.dart';
import 'package:flutter/material.dart';

class DrawerHeaderWidget extends StatelessWidget {
  final String? fullName;
  final String? uploadedImageUrl;

  const DrawerHeaderWidget({
    Key? key,
    required this.fullName,
    this.uploadedImageUrl,
  }) : super(key: key);

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
            Navigator.pop(context); // Close the drawer
            // Navigate to ProfileScreen with userData
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                          userData: UserData(
                        fullName: fullName ?? '',
                        imageUrl: uploadedImageUrl ?? '', id: '', email: '',
                        password: '', phoneNumber: '', address: '',
                        // Add other necessary fields from UserData model
                      ))),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 72,
                backgroundImage: uploadedImageUrl != null
                    ? FileImage(File(uploadedImageUrl!))
                    : const AssetImage('assets/imagens/profile_picture.jpg')
                        as ImageProvider,
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
