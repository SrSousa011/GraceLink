import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchapp/data/model/photos_data.dart';
import 'package:churchapp/views/photos/photo_viwer.dart';
import 'package:flutter/material.dart';

class PhotoItem extends StatelessWidget {
  final PhotoData photo;

  const PhotoItem({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            photo.location.isNotEmpty
                ? photo.location
                : 'Localização não informada',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
              backgroundColor: Colors.black54,
            ),
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
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
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
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.photo_library,
                      color: Colors.white,
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
