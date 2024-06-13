import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarSection extends StatefulWidget {
  const AvatarSection({
    super.key,
    required this.fullName,
    required this.location,
  });

  final String? fullName;
  final String location;

  @override
  State<AvatarSection> createState() => _AvatarSectionState();
}

class _AvatarSectionState extends State<AvatarSection> {
  bool isAvatarTapped = false;
  final ImagePicker _picker = ImagePicker();
  String? _uploadedImageUrl;

  Future<void> _uploadImage() async {
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null && mounted) {
      setState(() {
        _uploadedImageUrl = file.path; // Use the local file path
      });
    }
  }

  void _removeImage() {
    setState(() {
      _uploadedImageUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
                radius: isAvatarTapped ? 150 : 100, // Larger radius when tapped
                backgroundImage: _uploadedImageUrl != null
                    ? FileImage(File(_uploadedImageUrl!))
                    : const AssetImage('assets/imagens/avatar.png')
                        as ImageProvider,
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
        const SizedBox(height: 10),
        Text(
          widget.fullName ?? 'Loading...',
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
    );
  }
}
