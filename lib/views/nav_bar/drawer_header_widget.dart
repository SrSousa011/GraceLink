import 'package:churchapp/models/user_data.dart';
import 'package:churchapp/views/user_profile/user_profile.dart';
import 'package:flutter/material.dart';

const String tImageBackground = 'assets/imagens/bacground-image-center.jpg';

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
            image: AssetImage(tImageBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  userData: userData ??
                      UserData(
                        id: '',
                        fullName: 'Loading...',
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
                backgroundColor: Colors.grey[200],
                child: userData?.imagePath.isNotEmpty ?? false
                    ? CircleAvatar(
                        radius: 72,
                        backgroundImage: NetworkImage(userData!.imagePath),
                      )
                    : const Icon(
                        Icons.account_circle,
                        size: 144,
                        color: Colors.grey,
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
