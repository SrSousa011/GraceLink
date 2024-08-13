import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventImage extends StatelessWidget {
  final String? imageUrl;
  final String? localImagePath;
  final double imageHeight;

  const EventImage({
    super.key,
    this.imageUrl,
    this.localImagePath,
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
          : imageUrl != null && imageUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  errorWidget: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.red),
                      ),
                    );
                  },
                  placeholder: (context, url) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                )
              : const SizedBox.shrink(),
    );
  }
}
