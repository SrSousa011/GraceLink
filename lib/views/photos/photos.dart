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

  final int _limit = 20; // Número de fotos por página
  DocumentSnapshot? _lastDocument;
  bool _hasMorePhotos = true;
  final List<PhotoData> _allPhotos = [];
  List<PhotoData> _filteredPhotos = [];
  final String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchPhotos(); // Carregar fotos inicialmente
  }

  Future<void> _fetchPhotos() async {
    if (!_hasMorePhotos) return;

    try {
      Query query = _firestore
          .collection('photos')
          .orderBy('createdAt', descending: true)
          .limit(_limit);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot snapshot = await query.get();
      final photosData = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return PhotoData(
          urls: List<String>.from(data['urls'] ?? []),
          uploadId: data['uploadId'] ?? '',
          location: data['location'] ?? '',
          createdAt: data['createdAt'] as Timestamp,
        );
      }).toList();

      setState(() {
        _allPhotos.addAll(photosData);
        _filteredPhotos = _filterPhotos(_searchQuery);

        if (snapshot.docs.length < _limit) {
          _hasMorePhotos = false;
        } else {
          _lastDocument = snapshot.docs.last;
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar fotos: $e');
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Galeria de Foto',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchPhotos();
          }
          return false;
        },
        child: ListView(
          children: _filteredPhotos
              .map((photo) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    height: 300.0,
                    child: Column(
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
                        Expanded(
                          child: Stack(
                            children: [
                              ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: photo.urls.length,
                                itemBuilder: (context, index) {
                                  final photoUrl = photo.urls[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FullScreenPhotoPage(
                                            photoUrls: photo.urls,
                                            initialIndex: index,
                                          ),
                                        ),
                                      );
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: photoUrl,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                    ),
                                  );
                                },
                              ),
                              const Positioned(
                                bottom: 8.0,
                                right: 8.0,
                                child: Icon(
                                  Icons.photo_library,
                                  color: Colors.white,
                                  size: 30.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showImageSourceSelection,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<PhotoData> _filterPhotos(String query) {
    if (query.isEmpty) {
      return _allPhotos;
    } else {
      return _allPhotos
          .where((photo) =>
              photo.location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
