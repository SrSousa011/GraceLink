import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:churchapp/views/user_Profile/store_data.dart';
import 'package:churchapp/services/auth_service.dart';

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
  String? fullName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData(); // Carrega o nome de usuário
    loadProfileImage(); // Carrega a imagem ao iniciar a página
  }

  Future<void> fetchData() async {
    try {
      fullName = await AuthenticationService().getCurrentUserName();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching full name: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
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
  }

  void _saveImage() async {
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
    return Container(
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
          ElevatedButton(
            onPressed: _saveImage,
            child: const Text('Salvar Imagem'),
          ),
          const SizedBox(height: 20),
          if (isLoading) ...[
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            const Text('Carregando...'),
          ] else ...[
            Text(
              fullName ?? 'Nome não disponível',
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
    );
  }
}