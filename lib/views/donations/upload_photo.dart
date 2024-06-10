import 'dart:async';
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
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  Reference? _uploadedImageRef;
  String? _uploadedImageUrl;
  bool _uploading = false;
  String? uploadStatus;
  String? uploadedFileURL;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<bool> _clearUploadedImageState() async {
    Completer<bool> completer = Completer<bool>();

    try {
      if (_uploadedImageRef != null) {
        await _uploadedImageRef!.delete();
      }
      setState(() {
        uploadStatus = null;
        uploadedFileURL = null;
        _uploadedImageRef = null;
      });
      completer.complete(true);
    } catch (e) {
      completer.complete(false);
    }

    return completer.future;
  }

  Future<void> _loadImage() async {
    try {
      ListResult result = await storage.ref('images').listAll();
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
        UploadTask uploadTask = storage.ref(ref).putFile(uploadFile);

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
                            child: const Text('Confirm'),
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
                            child: const Text('Remove'),
                          ),
                        ],
                      ),
                    ),
                  ],
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
    await _clearUploadedImageState(); // Adicionado para limpar o estado após confirmar
  }
}
