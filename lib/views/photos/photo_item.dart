import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:churchapp/data/model/photos_data.dart';
import 'package:churchapp/views/photos/edit.dart';
import 'package:churchapp/views/photos/photo_viwer.dart';

class PhotoItem extends StatefulWidget {
  final PhotoData photo;
  final bool isAdmin;

  const PhotoItem({
    super.key,
    required this.photo,
    required this.isAdmin,
  });

  @override
  State<PhotoItem> createState() => _PhotoItemState();
}

class _PhotoItemState extends State<PhotoItem> {
  late PhotoData _photo;

  @override
  void initState() {
    super.initState();
    _photo = widget.photo;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                  _photo.location.isNotEmpty
                      ? _photo.location
                      : 'Localização não informada',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              if (widget.isAdmin)
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditPhotoScreen(photo: _photo),
                      ),
                    );

                    if (result == true) {
                      setState(() {
                        _photo = _photo;
                      });
                    }
                  },
                ),
            ],
          ),
        ),
        if (_photo.urls.isNotEmpty)
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
                          photoUrls: _photo.urls,
                          initialIndex: 0,
                        ),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: _photo.urls[0],
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              if (_photo.urls.length > 1)
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
