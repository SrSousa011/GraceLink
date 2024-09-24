import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/data/model/photos_data.dart';
import 'package:churchapp/views/photos/update_photos.dart';
import 'package:churchapp/views/photos/photo_viwer.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PhotosScreen extends StatelessWidget {
  final bool isAdmin;

  const PhotosScreen({super.key, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeria de Fotos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('photos')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhuma foto encontrada.'));
          }

          final photos = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return PhotoData(
              urls: List<String>.from(data['urls'] ?? []),
              uploadId: data['uploadId'] ?? '',
              location: data['location'] ?? '',
              createdAt: data['createdAt'] as Timestamp,
            );
          }).toList();

          return ListView(
            children: photos.map((photo) {
              return PhotoItem(
                photo: photo,
                isAdmin: isAdmin,
                onDownload: (uploadId) {},
                onDelete: (uploadId) => _deletePhoto(context, uploadId),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<void> _deletePhoto(BuildContext context, String uploadId) async {
    try {
      await FirebaseFirestore.instance
          .collection('photos')
          .doc(uploadId)
          .delete();

      final storageRef =
          FirebaseStorage.instance.ref().child('photos/$uploadId');
      await storageRef.delete();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir a foto: $e')),
      );
    }
  }
}

class PhotoItem extends StatelessWidget {
  final PhotoData photo;
  final bool isAdmin;
  final Function(String) onDownload;
  final Function(String) onDelete;

  const PhotoItem({
    super.key,
    required this.photo,
    required this.isAdmin,
    required this.onDownload,
    required this.onDelete,
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
    final editIconColor = isDarkMode
        ? const Color.fromARGB(255, 255, 255, 255)
        : const Color.fromARGB(255, 0, 255, 38);
    final editTextColor =
        isDarkMode ? Colors.white : const Color.fromARGB(255, 0, 0, 0);
    final downloadIconColor = isDarkMode ? Colors.white : Colors.blue;
    final downloadTextColor = isDarkMode ? Colors.white : Colors.black;
    final deleteIconColor = isDarkMode
        ? const Color.fromARGB(255, 255, 255, 255)
        : Colors.redAccent;
    final deleteTextColor = isDarkMode
        ? const Color.fromARGB(255, 255, 255, 255)
        : Colors.redAccent;

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
                        builder: (context) => UpdatePhotos(photoData: photo),
                      ),
                    );
                  } else if (value == 'download') {
                    onDownload(photo.uploadId);
                  } else if (value == 'delete' && isAdmin) {
                    showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar Exclusão'),
                        content: const Text(
                            'Você tem certeza que deseja excluir esta foto?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              onDelete(photo.uploadId);
                              Navigator.of(context).pop(true);
                            },
                            child: const Text('Excluir'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    if (isAdmin)
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(
                            LineAwesomeIcons.pencil_alt_solid,
                            color: editIconColor,
                          ),
                          title: Text(
                            'Editar',
                            style: TextStyle(
                              color: editTextColor,
                            ),
                          ),
                        ),
                      ),
                    PopupMenuItem<String>(
                      value: 'download',
                      child: ListTile(
                        leading: Icon(
                          LineAwesomeIcons.cloud_download_alt_solid,
                          color: downloadIconColor,
                        ),
                        title: Text(
                          'Download',
                          style: TextStyle(
                            color: downloadTextColor,
                          ),
                        ),
                      ),
                    ),
                    if (isAdmin)
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(
                            LineAwesomeIcons.trash_alt,
                            color: deleteIconColor,
                          ),
                          title: Text(
                            'Excluir',
                            style: TextStyle(
                              color: deleteTextColor,
                            ),
                          ),
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
