import 'dart:io';
import 'package:churchapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:churchapp/views/user_Profile/store_data.dart';

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
  String fullName = '';
  String bio = '';

  @override
  void initState() {
    super.initState();
    getDada();
  }

  void getDada() async {
    fullName = (await AuthenticationService().getCurrentUserName())!;
    bio = (await AuthenticationService().getAddress())!;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _uploadImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null && mounted) {
      setState(() {
        _uploadedImageUrl = file.path; // Use local file path
      });
      await _saveImage();
    }
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
    return GestureDetector(
      onTap: () {
        setState(() {
          isAvatarTapped = !isAvatarTapped;
        });
      },
      child: Column(
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: <Widget>[
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: _uploadedImageUrl != null
                      ? (_uploadedImageUrl!.startsWith('http')
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(_uploadedImageUrl!),
                            )
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(File(_uploadedImageUrl!)),
                            ))
                      : null,
                  color: Colors.grey[200],
                ),
                child: _uploadedImageUrl == null
                    ? const Icon(
                        Icons.account_circle,
                        size: 120,
                        color: Colors.grey,
                      )
                    : null,
              ),
              if (isAvatarTapped)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'update') {
                          _uploadImage();
                        } else if (value == 'remove') {
                          _removeImage();
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'update',
                          child: ListTile(
                            leading: Icon(Icons.edit, color: Colors.blue),
                            title: Text('Atualizar Foto'),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'remove',
                          child: ListTile(
                            leading: Icon(Icons.delete, color: Colors.red),
                            title: Text('Remover Foto'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            fullName,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            bio,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
