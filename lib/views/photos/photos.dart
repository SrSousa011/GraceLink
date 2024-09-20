import 'dart:io';
import 'dart:typed_data';
import 'package:churchapp/data/model/photos_data.dart';
import 'package:churchapp/data/model/user_data.dart';
import 'package:churchapp/views/photos/image_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'photo_item.dart';
import 'preview_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  bool _isAdmin = false;
  bool _isSearching = false;
  String _searchQuery = '';
  List<PhotoData> _allPhotos = [];
  List<PhotoData> _filteredPhotos = [];

  @override
  void initState() {
    super.initState();
    _fetchUserRole();
  }

  Future<void> _fetchUserRole() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userId = user.uid;
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final userData = UserData.fromDocument(doc);

      setState(() {
        _isAdmin = userData.role == 'admin';
      });
    } catch (e) {
      // Error handling
    }
  }

  Future<void> _fetchPhotos() async {
    final snapshot = await _firestore
        .collection('photos')
        .orderBy('createdAt', descending: true)
        .get();
    _allPhotos = snapshot.docs.map((doc) {
      final data = doc.data();
      return PhotoData(
        urls: List<String>.from(data['urls'] ?? []),
        uploadId: data['uploadId'] ?? '',
        location: data['location'] ?? '',
        createdAt: data['createdAt'] as Timestamp,
      );
    }).toList();
    _filteredPhotos = _filterPhotos(_searchQuery);
  }

  List<PhotoData> _filterPhotos(String query) {
    if (query.isEmpty) {
      return _allPhotos;
    }
    final lowercasedQuery = query.toLowerCase();
    return _allPhotos.where((photo) {
      return photo.location.toLowerCase().contains(lowercasedQuery);
    }).toList();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
      _filteredPhotos = _filterPhotos(_searchQuery);
    });
  }

  Future<void> _showImageSourceSelection() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageSourceDialog(
          onPickMultiple: _pickMultipleImages,
          onPickSingle: _pickSingleImage,
          onPickFromCamera: _pickImageFromCamera,
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
      final locationDocRef = _firestore.collection('photos').doc(uploadId);
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
      // Error handling
    }
  }

  Future<void> _handleOpenUrl(String uploadId) async {
    try {
      final photoDoc =
          await _firestore.collection('photos').doc(uploadId).get();
      if (!photoDoc.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Arquivo não encontrado!')),
          );
        }
        return;
      }

      final data = photoDoc.data();
      final imageUrls = List<String>.from(data!['urls'] ?? []);
      String location = data['location'] ?? 'default_location';

      if (imageUrls.isNotEmpty) {
        for (int i = 0; i < imageUrls.length; i++) {
          String imageUrl = imageUrls[i];
          await _downloadImage(imageUrl, location, i + 1);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('URL da imagem não disponível.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao abrir a imagem: $e'),
          ),
        );
      }
    }
  }

  Future<void> _downloadImage(String url, String location, int index) async {
    try {
      Directory? directory;

      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        throw UnsupportedError('Plataforma não suportada');
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filePath = '${directory.path}/$location-$index.jpg';
      final response = await Dio().download(url, filePath);

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Download concluído!')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro no download.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao fazer download: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: _isSearching
                ? TextField(
                    autofocus: true,
                    onChanged: _updateSearchQuery,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Pesquisar fotos...',
                    ),
                  )
                : const Text('Galeria de Foto'),
            floating: true,
            pinned: true,
            actions: [
              _isSearching
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                          _searchQuery = '';
                          _updateSearchQuery('');
                        });
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _isSearching = true;
                        });
                      },
                    ),
            ],
          ),
          SliverFillRemaining(
            child: FutureBuilder<void>(
              future: _fetchPhotos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                if (_filteredPhotos.isEmpty) {
                  return const Center(child: Text('Nenhuma foto encontrada.'));
                }

                return ListView.builder(
                  itemCount: _filteredPhotos.length,
                  itemBuilder: (context, index) {
                    final photo = _filteredPhotos[index];
                    return PhotoItem(
                      photo: photo,
                      isAdmin: _isAdmin,
                      onDownload: _handleOpenUrl,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              onPressed: _showImageSourceSelection,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
