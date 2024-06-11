import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({Key? key}) : super(key: key);

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  Reference? _uploadedImageRef;
  String? _uploadedImageUrl;
  bool _uploading = false;

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
        _uploadedImageUrl = null;
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading image')),
        );
      }
      setState(() {
        _uploading = false;
      });
    }
  }

  Future<void> _uploadImage() async {
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null && context.mounted) {
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

        // Wait for the upload to complete
        await uploadTask.whenComplete(() async {
          // Get the download URL
          _uploadedImageUrl = await storage.ref(ref).getDownloadURL();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('File Uploaded Successfully')),
            );
          }
        });

        setState(() {
          _uploading = false;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Upload Error')),
          );
        }
      }
    }
  }

  Future<void> _removeImage() async {
    try {
      if (_uploadedImageRef != null) {
        await _uploadedImageRef!.delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File Removed Successfully')),
          );
        }
        setState(() {
          _uploadedImageRef = null;
          _uploadedImageUrl = null;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error removing image: $e');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error removing image')),
        );
      }
    }
  }

  Future<void> _confirmAndNavigateBack() async {
    if (_uploadedImageUrl != null) {
      try {
        // Save donation details to Firestore
        await FirebaseFirestore.instance.collection('donations').add({
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'fullName': 'Sergio Ribas Camargo',
          'donationType': 'Type',
          'donationValue': 'Value',
          'photoURL': _uploadedImageUrl,
          'timestamp': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Donation successfully completed')),
          );
        }

        Navigator.of(context).pop(_uploadedImageUrl);
        await _clearUploadedImageState();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to complete donation: $e'),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload an image before confirming.'),
        ),
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
}
