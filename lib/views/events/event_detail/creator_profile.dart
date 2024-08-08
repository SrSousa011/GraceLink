import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CreatorProfileOverlay extends StatelessWidget {
  final String? imageUrl;
  final String name;

  const CreatorProfileOverlay({
    super.key,
    this.imageUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16.0,
      left: 16.0,
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:
                imageUrl != null ? CachedNetworkImageProvider(imageUrl!) : null,
            radius: 24.0,
            backgroundColor: Colors.grey[300],
            child: imageUrl == null
                ? const Icon(Icons.person, color: Colors.grey)
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
      ),
    );
  }
}
