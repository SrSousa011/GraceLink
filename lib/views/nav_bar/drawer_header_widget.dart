import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchapp/data/model/user_data.dart';
import 'package:churchapp/views/user_profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const String tImageBackground = 'assets/imagens/bacground-image-center.jpg';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: double.infinity,
            height: 270,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage(tImageBackground),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox(
            width: double.infinity,
            height: 270,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage(tImageBackground),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(child: Text('User data not found')),
            ),
          );
        }

        final userData = UserData.fromDocument(snapshot.data!);

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
                      userData: userData,
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
                    child: userData.imagePath.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: userData.imagePath,
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 72,
                              backgroundImage: imageProvider,
                            ),
                            placeholder: (context, url) => const Icon(
                              Icons.account_circle,
                              size: 144,
                              color: Colors.grey,
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              size: 144,
                              color: Colors.red,
                            ),
                          )
                        : const Icon(
                            Icons.account_circle,
                            size: 144,
                            color: Colors.grey,
                          ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    userData.fullName.isNotEmpty
                        ? userData.fullName
                        : 'Loading...',
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
