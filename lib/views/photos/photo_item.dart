import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchapp/views/photos/update_photos.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/data/model/photos_data.dart';
import 'package:churchapp/views/photos/photo_viwer.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class PhotoItem extends StatelessWidget {
  final PhotoData photo;
  final bool isAdmin;
  final Function(String) onDownload;

  const PhotoItem({
    super.key,
    required this.photo,
    required this.isAdmin,
    required this.onDownload,
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
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit' && isAdmin) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UpdatePhotos(
                          photoData: photo,
                        ),
                      ),
                    );
                  } else if (value == 'download') {
                    onDownload(photo.uploadId);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    if (isAdmin)
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(LineAwesomeIcons.pencil_alt_solid,
                              color:
                                  isDarkMode ? Colors.grey[300] : Colors.red),
                          title: Text('Editar',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.red)),
                        ),
                      ),
                    PopupMenuItem<String>(
                      value: 'download',
                      child: ListTile(
                        leading: Icon(LineAwesomeIcons.cloud_download_alt_solid,
                            color: isDarkMode ? Colors.white : Colors.blue),
                        title: Text('Download',
                            style: TextStyle(
                                color:
                                    isDarkMode ? Colors.white : Colors.black)),
                      ),
                    ),
                  ];
                },
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