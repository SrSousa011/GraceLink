import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class StoreData {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    try {
      Reference ref = _storage.ref().child(childName);
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (err) {
      if (kDebugMode) {
        print('Error uploading image to storage: $err');
      }
      throw err.toString();
    }
  }

  Future<void> saveProfileImage(String downloadURL) async {
    try {
      await _firestore.collection("userProfile").doc("profile").set({
        'imageLink': downloadURL,
      });
    } catch (err) {
      if (kDebugMode) {
        print('Error saving profile image: $err');
      }
      throw err.toString();
    }
  }

  Future<String> getProfileImage() async {
    try {
      String downloadURL =
          await _storage.ref().child('profile_images').getDownloadURL();
      return downloadURL;
    } catch (err) {
      if (kDebugMode) {
        print('Error getting profile image: $err');
      }
      throw err.toString();
    }
  }
}
