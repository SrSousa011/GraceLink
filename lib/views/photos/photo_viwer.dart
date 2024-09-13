import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullScreenPhotoPage extends StatelessWidget {
  final List<String> photoUrls;
  final int initialIndex;

  const FullScreenPhotoPage({
    super.key,
    required this.photoUrls,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: photoUrls.length,
        controller: PageController(initialPage: initialIndex),
        itemBuilder: (context, index) {
          return Center(
            child: CachedNetworkImage(
              imageUrl: photoUrls[index],
              fit: BoxFit.contain,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          );
        },
      ),
    );
  }
}
