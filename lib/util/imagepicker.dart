import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImagePickerr {
  final FirebaseStorage _storage;
  final FirebaseFirestore _firestore;
  final ImagePicker _picker;
  final String userId;

  ImagePickerr({
    required FirebaseStorage storage,
    required FirebaseFirestore firestore,
    required ImagePicker picker,
    required this.userId,
  })  : _storage = storage,
        _firestore = firestore,
        _picker = picker;

  Future<void> updateProfilePicture(
      VoidCallback onSuccess, Function(String)? onError) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      try {
        UploadTask uploadTask = _storage
            .ref()
            .child('userProfilePictures/$userId/profilePicture.jpg')
            .putFile(file);

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        await _firestore
            .collection('users')
            .doc(userId)
            .update({'imagePath': downloadURL});

        onSuccess();
      } catch (e) {
        if (kDebugMode) {
          print("Error uploading image: $e");
        }
        if (onError != null) {
          onError(e.toString());
        }
      }
    }
  }
}
