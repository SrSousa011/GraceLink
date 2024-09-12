import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;

class PhotoGalleryPage extends StatefulWidget {
  const PhotoGalleryPage({super.key});

  @override
  _PhotoGalleryPageState createState() => _PhotoGalleryPageState();
}

class _PhotoGalleryPageState extends State<PhotoGalleryPage> {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        final fileName = path.basename(pickedFile.path);
        final file = await pickedFile.readAsBytes();
        final storageRef = _storage.ref().child('photos/$fileName');

        // Upload the image
        final uploadTask = storageRef.putData(file);
        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        // Save the image URL to Firestore
        await _firestore.collection('photos').add({'url': downloadUrl});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto carregada com sucesso')),
        );
      } catch (e) {
        if (kDebugMode) {
          print('Erro ao carregar a imagem: $e');
        }
      }
    }
  }

  Stream<List<String>> _getPhotoUrls() {
    return _firestore.collection('photos').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => doc['url'] as String).toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeria de Fotos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo),
            onPressed: _pickAndUploadImage,
          ),
        ],
      ),
      body: StreamBuilder<List<String>>(
        stream: _getPhotoUrls(),
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

          final photoUrls = snapshot.data!;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: photoUrls.length,
            itemBuilder: (context, index) {
              return Image.network(
                photoUrls[index],
                fit: BoxFit.cover,
              );
            },
          );
        },
      ),
    );
  }
}
