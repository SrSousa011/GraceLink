import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreatorProfileOverlay extends StatelessWidget {
  final String userId;
  final String name;

  const CreatorProfileOverlay({
    super.key,
    required this.userId,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final userStream =
        FirebaseFirestore.instance.collection('users').doc(userId).snapshots();

    return Positioned(
      bottom: 16.0,
      left: 16.0,
      child: StreamBuilder<DocumentSnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildProfileContent(null, true);
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return _buildProfileContent(null, false);
          }

          final userData = snapshot.data!;
          final imageUrl = userData['imagePath'] as String?;

          return _buildProfileContent(imageUrl, false);
        },
      ),
    );
  }

  Widget _buildProfileContent(String? imageUrl, bool isLoading) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage:
              imageUrl != null ? CachedNetworkImageProvider(imageUrl) : null,
          radius: 24.0,
          backgroundColor: Colors.grey[300],
          child: imageUrl == null
              ? isLoading
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.person, color: Colors.grey)
              : null,
        ),
        const SizedBox(width: 8.0),
        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            backgroundColor: Colors.black54,
          ),
        ),
      ],
    );
  }
}
