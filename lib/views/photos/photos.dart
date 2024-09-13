import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchapp/data/model/photos_data.dart';
import 'package:churchapp/views/photos/photo_viwer.dart';
import 'package:churchapp/views/photos/preview_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'dart:typed_data';

class PhotoGalleryPage extends StatefulWidget {
  const PhotoGalleryPage({super.key});

  @override
  State<PhotoGalleryPage> createState() => _PhotoGalleryPageState();
}

class _PhotoGalleryPageState extends State<PhotoGalleryPage> {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<XFile> _pickedFiles = [];
  XFile? _selectedImage;
  final TextEditingController _locationController = TextEditingController();

  Future<void> _showImageSourceSelection() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecionar ou Capturar a Foto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Selecionar Múltiplas Fotos'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickMultipleImages();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Escolher uma Foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickSingleImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tirar uma Nova Foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickMultipleImages() async {
    final pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _pickedFiles.clear();
        _pickedFiles.addAll(pickedFiles);
        _selectedImage = _pickedFiles.isNotEmpty ? _pickedFiles[0] : null;
      });
      _showPreviewScreen();
    }
  }

  Future<void> _pickSingleImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedFiles.clear();
        _pickedFiles.add(pickedFile);
        _selectedImage = pickedFile;
      });
      _showPreviewScreen();
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _pickedFiles.clear();
        _pickedFiles.add(pickedFile);
        _selectedImage = pickedFile;
      });
      _showPreviewScreen();
    }
  }

  void _showPreviewScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          imageFile: _selectedImage!,
          files: _pickedFiles,
          onLocationAdded: () => _addLocationAndUpload(),
          locationController: _locationController,
        ),
      ),
    );
  }

  Future<void> _addLocationAndUpload() async {
    final location = _locationController.text.trim();
    if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, adicione uma localização.')),
      );
      return;
    }

    try {
      final uploadId = DateTime.now().millisecondsSinceEpoch.toString();
      final locationDocRef = _firestore.collection('photos').doc(location);
      final List<String> imageUrls = [];

      for (final file in _pickedFiles) {
        final fileName =
            '${path.basename(file.path).replaceAll(RegExp(r'\.[^\.]+$'), '')}_$location${path.extension(file.path)}';

        final fileData = await file.readAsBytes();
        final storageRef = _storage.ref().child('photos/$fileName/$uploadId');

        final uploadTask = storageRef.putData(Uint8List.fromList(fileData));
        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        imageUrls.add(downloadUrl);
      }

      await locationDocRef.set({
        'location': location,
        'uploadId': uploadId,
        'createdAt': Timestamp.now(),
        'urls': imageUrls,
      });

      setState(() {
        _pickedFiles.clear();
        _locationController.clear();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao carregar a imagem: $e');
      }
    }
  }

  Future<List<PhotoData>> _getPhotosWithLocations() async {
    try {
      final querySnapshot = await _firestore
          .collection('photos')
          .orderBy('createdAt', descending: true)
          .get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return PhotoData(
          urls: List<String>.from(data['urls'] ?? []),
          uploadId: '',
          location: data['location'] ?? '',
          createdAt: data['createdAt'] as Timestamp,
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao recuperar as fotos: $e');
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Galeria de Foto',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: FutureBuilder<List<PhotoData>>(
              future: _getPhotosWithLocations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return const SliverFillRemaining(
                      child: Center(child: Text('Erro ao carregar fotos')));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SliverFillRemaining(
                      child: Center(child: Text('Nenhuma foto encontrada')));
                }

                final photos = snapshot.data!;
                final groupedPhotos = <String, List<PhotoData>>{};

                for (var photo in photos) {
                  final location = photo.location;
                  if (!groupedPhotos.containsKey(location)) {
                    groupedPhotos[location] = [];
                  }
                  groupedPhotos[location]!.add(photo);
                }

                final groupedKeys = groupedPhotos.keys.toList();

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= groupedKeys.length) {
                        return null;
                      }
                      final location = groupedKeys[index];
                      final group = groupedPhotos[location]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              location.isNotEmpty
                                  ? location
                                  : 'Localização não informada',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          GridView.builder(
                            padding: const EdgeInsets.all(8.0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                            itemCount: group.fold<int>(
                                0, (prev, photo) => prev + photo.urls.length),
                            itemBuilder: (context, index) {
                              int count = 0;
                              PhotoData? selectedPhoto;

                              for (var photo in group) {
                                if (index < count + photo.urls.length) {
                                  selectedPhoto = photo;
                                  break;
                                }
                                count += photo.urls.length;
                              }

                              if (selectedPhoto == null) {
                                return const SizedBox.shrink();
                              }

                              final photoUrl =
                                  selectedPhoto.urls[index - count];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => FullScreenPhotoPage(
                                        photoUrls: selectedPhoto!.urls,
                                        initialIndex: index - count,
                                      ),
                                    ),
                                  );
                                },
                                child: CachedNetworkImage(
                                  imageUrl: photoUrl,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                    childCount: groupedKeys.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 247, 207, 107),
              Color.fromARGB(255, 237, 117, 80),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          onPressed: _showImageSourceSelection,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 40),
        ),
      ),
    );
  }
}
