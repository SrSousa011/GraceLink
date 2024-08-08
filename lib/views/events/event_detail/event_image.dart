import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventImage extends StatelessWidget {
  final String? imageUrl;
  final String? localImagePath;

  const EventImage({
    super.key,
    this.imageUrl,
    this.localImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return localImagePath != null
        ? Image.file(
            File(localImagePath!),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          )
        : imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, error, stackTrace) {
                  return const Center(child: Text('Error loading image'));
                },
                placeholder: (context, url) {
                  return Container(
                    color: Colors.grey[300],
                    height: 200,
                    width: double.infinity,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              )
            : const SizedBox.shrink();
  }
}
