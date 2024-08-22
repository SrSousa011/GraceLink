import 'dart:io';

import 'package:churchapp/views/donations/donations.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StoragePage extends StatefulWidget {
  final String donationType;
  final String donationValue;
  final String fullName;

  const StoragePage({
    super.key,
    required this.donationType,
    required this.donationValue,
    required this.fullName,
  });

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  final ImagePicker _picker = ImagePicker();
  String? _uploadedImageUrl;

  Future<void> _uploadImage() async {
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null && context.mounted) {
      try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef =
            FirebaseStorage.instance.ref().child('donations/$fileName');

        await storageRef.putFile(File(file.path));

        String downloadURL = await storageRef.getDownloadURL();

        setState(() {
          _uploadedImageUrl = downloadURL;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error uploading image')),
          );
        }
      }
    }
  }

  void _removeImage() {
    setState(() {
      _uploadedImageUrl = null;
    });
  }

  Future<void> _confirmAndNavigateBack() async {
    if (_uploadedImageUrl != null) {
      try {
        await FirebaseFirestore.instance.collection('donations').add({
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'fullName': widget.fullName,
          'donationType': widget.donationType,
          'donationValue': widget.donationValue,
          'photoURL': _uploadedImageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Doação concluída com sucesso')),
          );
        }

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Donations()),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Falha ao concluir a doação: $e'),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, carregue uma imagem antes de confirmar.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da doação'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: _uploadedImageUrl != null ? null : _uploadImage,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_uploadedImageUrl != null)
              Card(
                margin: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 5,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(10.0)),
                      child: Image.network(
                        _uploadedImageUrl!,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: _confirmAndNavigateBack,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text('Confirmar'),
                          ),
                          ElevatedButton(
                            onPressed: _removeImage,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (_uploadedImageUrl == null)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Por favor, carregue uma imagem.'),
              ),
          ],
        ),
      ),
    );
  }
}
