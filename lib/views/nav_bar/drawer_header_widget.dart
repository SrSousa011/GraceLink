import 'package:churchapp/models/user_data.dart';
import 'package:churchapp/views/user_Profile/user_profile.dart';
import 'package:flutter/material.dart';

class DrawerHeaderWidget extends StatelessWidget {
  final UserData? userData;

  const DrawerHeaderWidget({
    super.key,
    this.userData,
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
                  userData: userData ??
                      UserData(
                        id: '',
                        fullName: 'Guest',
                        address: '',
                        imagePath: '',
                      ),
                ),
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 72,
                backgroundColor:
                    Colors.grey[200], // Background color of CircleAvatar
                child: userData?.imagePath.isNotEmpty ?? false
                    ? CircleAvatar(
                        radius: 72,
                        backgroundImage: NetworkImage(userData!.imagePath),
                      )
                    : const Icon(
                        Icons.account_circle,
                        size: 144, // Icon size inside CircleAvatar
                        color: Colors.grey, // Icon color
                      ),
              ),
              const SizedBox(height: 12),
              Text(
                userData?.fullName ?? 'Loading...',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
