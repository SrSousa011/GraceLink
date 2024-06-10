import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  Reference? _uploadedImageRef;
  String? _uploadedImageUrl;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      ListResult result = await firebaseStorage.ref('images').listAll();
      if (result.items.isNotEmpty) {
        // Load only the first image if exists
        _uploadedImageRef = result.items[0];
        _uploadedImageUrl = await _uploadedImageRef!.getDownloadURL();
      } else {
        _uploadedImageRef = null;
        _uploadedImageUrl = null;
      }
      setState(() {
        _uploading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading image: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error loading image')),
      );
      setState(() {
        _uploading = false;
      });
    }
  }

  Future<void> _uploadImage() async {
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      try {
        File uploadFile = File(file.path);
        String ref = 'images/img-${DateTime.now().millisecondsSinceEpoch}.jpg';
        UploadTask uploadTask = firebaseStorage.ref(ref).putFile(uploadFile);

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            _uploading = true;
          });
        }, onError: (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Upload Error')),
          );
        });

        await uploadTask.whenComplete(() => _loadImage());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File Uploaded Successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload Error')),
        );
      }
    }
  }

  Future<void> _removeImage() async {
    try {
      if (_uploadedImageRef != null) {
        await _uploadedImageRef!.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File Removed Successfully')),
        );
        setState(() {
          _uploadedImageRef = null;
          _uploadedImageUrl = null;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error removing image: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error removing image')),
      );
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      String ref = 'images/img-${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask uploadTask = firebaseStorage.ref(ref).putFile(imageFile);

      await uploadTask.whenComplete(() => _loadImage());

      return await firebaseStorage.ref(ref).getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Storage'),
        elevation: 0,
        actions: [
          if (_uploading)
            const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed:
                _uploading || _uploadedImageUrl != null ? null : _uploadImage,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_uploadedImageUrl != null)
              Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Image.network(_uploadedImageUrl!),
                  trailing: Wrap(
                    spacing: 12, // space between each button
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _confirmAndNavigateBack,
                        child: const Text('Confirm'),
                      ),
                      ElevatedButton(
                        onPressed: _removeImage,
                        child: const Text('Remove Image'),
                      ),
                    ],
                  ),
                ),
              ),
            if (_uploading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmAndNavigateBack() async {
    // Here you can perform any confirmation logic
    // For this example, let's just navigate back
    Navigator.of(context).pop(_uploadedImageUrl);
  }
}
