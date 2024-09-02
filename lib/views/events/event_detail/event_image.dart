import 'dart:io';
import 'package:flutter/material.dart';

class EventImage extends StatelessWidget {
  final String? localImagePath;
  final double imageHeight;
  final Stream<String?>? imageUrlStream;

  const EventImage({
    super.key,
    this.localImagePath,
    this.imageUrlStream,
    this.imageHeight = 400.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width,
      height: imageHeight,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: localImagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.zero,
              child: Image.file(
                File(localImagePath!),
                fit: BoxFit.cover,
              ),
            )
          : StreamBuilder<String?>(
              stream: imageUrlStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  );
                }

                final imageUrl = snapshot.data;
                if (imageUrl != null && imageUrl.isNotEmpty) {
                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.error, color: Colors.red),
                        ),
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
    );
  }
}
