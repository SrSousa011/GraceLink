import 'package:flutter/material.dart';

class ImageSourceDialog extends StatelessWidget {
  final VoidCallback onPickMultiple;
  final VoidCallback onPickSingle;
  final VoidCallback onPickFromCamera;

  const ImageSourceDialog({
    super.key,
    required this.onPickMultiple,
    required this.onPickSingle,
    required this.onPickFromCamera,
  });

  @override
  Widget build(BuildContext context) {
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
              onPickMultiple();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Escolher uma Foto'),
            onTap: () {
              Navigator.of(context).pop();
              onPickSingle();
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Tirar uma Nova Foto'),
            onTap: () {
              Navigator.of(context).pop();
              onPickFromCamera();
            },
          ),
        ],
      ),
    );
  }
}
