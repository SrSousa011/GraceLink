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

  @override
  void initState() {
    super.initState();
    fetchData();
    loadProfileImage(); // Carrega a imagem ao iniciar a página
  }

  void fetchData() async {
    fullName = await AuthenticationService().getCurrentUserName();
    if (mounted) {
      setState(() {});
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
        // Image saved successfully
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image saved successfully')),
        );
      } else {
        // Handle error
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save image: $resp')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload an image first')),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _uploadedImageUrl = null;
    });
  }

  Future<void> loadProfileImage() async {
    try {
      String imageUrl = await StoreData().getProfileImage();
      if (mounted) {
        setState(() {
          _uploadedImageUrl = imageUrl;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading profile image: $e');
      }
    }
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
                  radius:
                      isAvatarTapped ? 150 : 100, // Larger radius when tapped
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
              child: const Text('Remove Image'),
            ),
          ElevatedButton(
            onPressed: _saveImage,
            child: const Text('Save Image'),
          ),
          const SizedBox(height: 10),
          Text(
            fullName ?? 'Loading...',
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
      ),
    );
  }
}
