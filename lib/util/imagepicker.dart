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

    if (pickedFile == null) {
      if (onError != null) {
        onError("No image selected.");
      }
      return;
    }

    File file = File(pickedFile.path);

    if (!await file.exists()) {
      if (onError != null) {
        onError("Selected file does not exist.");
      }
      return;
    }

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
      String errorMessage;
      if (e is FirebaseException) {
        errorMessage = "Firebase error: ${e.message}";
      } else if (e is IOException) {
        errorMessage = "I/O error: ${e.toString()}";
      } else {
        errorMessage = "Unexpected error: ${e.toString()}";
      }

      if (kDebugMode) {
        print("Error uploading image: $errorMessage");
      }

      if (onError != null) {
        onError(errorMessage);
      }
    }
  }
}
