import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;

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
  final TextEditingController _locationController = TextEditingController();

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _pickedFiles.addAll(pickedFiles);
      });
      _showLocationDialog();
    }
  }

  void _showLocationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar Localização'),
          content: TextField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Localização',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _addLocationAndUpload();
              },
              child: const Text('Adicionar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
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

      for (final file in _pickedFiles) {
        final fileName = path.basename(file.path);
        final fileData = await file.readAsBytes();
        final storageRef = _storage.ref().child('photos/$uploadId/$fileName');

        final uploadTask = storageRef.putData(fileData);
        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        await _firestore.collection('photos').add({
          'url': downloadUrl,
          'uploadId': uploadId,
          'location': location,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fotos carregadas com sucesso')),
      );

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

  Future<List<Map<String, dynamic>>> _getPhotosWithLocations() async {
    try {
      final querySnapshot = await _firestore.collection('photos').get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'url': data['url'] as String,
          'uploadId': data['uploadId'] as String,
          'location': data['location'] as String,
        };
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
        title: const Text('Galeria de Fotos'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getPhotosWithLocations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma foto encontrada.'));
          }

          final photos = snapshot.data!;
          final groupedPhotos = <String, List<Map<String, dynamic>>>{};

          for (var photo in photos) {
            final uploadId = photo['uploadId']!;
            if (!groupedPhotos.containsKey(uploadId)) {
              groupedPhotos[uploadId] = [];
            }
            groupedPhotos[uploadId]!.add(photo);
          }

          return ListView.builder(
            itemCount: groupedPhotos.length,
            itemBuilder: (context, index) {
              final uploadId = groupedPhotos.keys.elementAt(index);
              final group = groupedPhotos[uploadId]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      group.first['location'] ?? 'Localização não informada',
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
                    itemCount: group.length,
                    itemBuilder: (context, index) {
                      final photo = group[index];
                      return CachedNetworkImage(
                        imageUrl: photo['url']!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: _pickImages,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 80,
            height: 80,
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
            child: const Icon(Icons.add, color: Colors.white, size: 40),
          ),
        ),
      ),
    );
  }
}
