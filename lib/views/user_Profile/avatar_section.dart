import 'dart:io';
import 'package:churchapp/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:churchapp/views/user_Profile/store_data.dart';
import 'package:provider/provider.dart';

class AvatarSection extends StatefulWidget {
  const AvatarSection({
    super.key,
    required this.location,
    String? fullName,
  });

  final String location;

  @override
  State<AvatarSection> createState() => _AvatarSectionState();
}

class _AvatarSectionState extends State<AvatarSection> {
  bool isAvatarTapped = false;
  final ImagePicker _picker = ImagePicker();
  String? _uploadedImageUrl;
  bool isLoading = true;
  String fullName = '';

  @override
  void initState() {
    super.initState();
    loadProfileImage(); // Carrega a imagem ao iniciar a página
    getUser();
  }

  void getUser() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        fullName = data['fullName'];
      });
    } else {
      if (kDebugMode) {
        print('User document does not exist');
      }
    }
  }

  Future<void> loadProfileImage() async {
    try {
      String imageUrl = await StoreData().getProfileImage();
      if (mounted) {
        setState(() {
          _uploadedImageUrl = imageUrl;
          isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading profile image: $e');
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null && mounted) {
      setState(() {
        _uploadedImageUrl = file.path;
      });
    }
    await _saveImage();
  }

  Future<void> _saveImage() async {
    if (_uploadedImageUrl != null) {
      File imageFile = File(_uploadedImageUrl!);
      String resp =
          await StoreData().saveData(file: imageFile.readAsBytesSync());
      if (resp == 'Success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imagem salva com sucesso')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao salvar imagem: $resp')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, carregue uma imagem primeiro')),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _uploadedImageUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  isAvatarTapped = !isAvatarTapped;
                });
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: isAvatarTapped ? 150 : 100,
                    backgroundImage: _uploadedImageUrl != null
                        ? Image.network(_uploadedImageUrl!).image
                        : const AssetImage('assets/imagens/avatar.png'),
                  ),
                  Positioned(
                    bottom: -10,
                    left: 150,
                    child: IconButton(
                      onPressed: _uploadImage,
                      icon: const Icon(Icons.add_a_photo),
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (_uploadedImageUrl != null)
              ElevatedButton(
                onPressed: _removeImage,
                child: const Text('Remover Imagem'),
              ),
            const SizedBox(height: 20),
            if (isLoading) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              const Text('Carregando...'),
            ] else ...[
              Text(
                fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.blue),
                  const SizedBox(width: 5),
                  Text(
                    widget.location,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
