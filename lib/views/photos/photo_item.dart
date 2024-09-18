import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/data/model/photos_data.dart';

import 'package:churchapp/views/photos/photo_viwer.dart';

class PhotoItem extends StatelessWidget {
  final PhotoData photo;
  final bool isAdmin;

  const PhotoItem({
    super.key,
    required this.photo,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final overlayColor = isDarkMode
        ? Colors.black.withOpacity(0.7)
        : Colors.white.withOpacity(0.7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  photo.location.isNotEmpty
                      ? photo.location
                      : 'Localização não informada',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (photo.urls.isNotEmpty)
          Stack(
            children: [
              SizedBox(
                width: screenWidth,
                height: screenHeight * 0.45,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FullScreenPhotoPage(
                          photoUrls: photo.urls,
                          initialIndex: 0,
                        ),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: photo.urls[0],
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              if (photo.urls.length > 1)
                Positioned(
                  bottom: 8.0,
                  right: 8.0,
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: overlayColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.photo_library,
                      color: textColor,
                      size: 24.0,
                    ),
                  ),
                ),
            ],
          ),
        const SizedBox(height: 90.0),
      ],
    );
  }
}
