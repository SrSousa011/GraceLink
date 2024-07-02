import 'dart:io';
import 'package:churchapp/models/user_data.dart';
import 'package:churchapp/provider/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:churchapp/views/user_Profile/store_data.dart';
import 'package:provider/provider.dart';

class AvatarSection extends StatefulWidget {
  final String fullName;
  final String address;

  const AvatarSection({
    super.key,
    required this.fullName,
    required this.address,
  });

  @override
  State<AvatarSection> createState() => _AvatarSectionState();
}

class _AvatarSectionState extends State<AvatarSection> {
  bool isAvatarTapped = false;
  final ImagePicker _picker = ImagePicker();
  String? _uploadedImageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfileImage();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avatar Section'),
      ),
      body: SingleChildScrollView(
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
            Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                UserData? userData = userProvider.getUser;
                if (isLoading) {
                  return const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Carregando...'),
                    ],
                  );
                } else if (userData != null) {
                  return Column(
                    children: [
                      Text(
                        userData.fullName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userData.address,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Text(
                    'Dados do usuário não encontrados',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
