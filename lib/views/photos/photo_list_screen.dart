import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/provider/photo_provider.dart';
import 'package:churchapp/views/photos/photo_item.dart';

class PhotoListScreen extends StatelessWidget {
  const PhotoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photos')),
      body: Consumer<PhotoProvider>(
        builder: (context, photoProvider, child) {
          return ListView.builder(
            itemCount: photoProvider.photos.length,
            itemBuilder: (context, index) {
              final photo = photoProvider.photos[index];
              return PhotoItem(
                photo: photo,
                isAdmin: true,
              );
            },
          );
        },
      ),
    );
  }
}
