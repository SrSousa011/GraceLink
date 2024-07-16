import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class StoreData {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    try {
      Reference ref = _storage.ref().child('userProfile');
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

  Future<String> saveData({required Uint8List file}) async {
    try {
      // Upload image to Firebase Storage
      String imagePath = await uploadImageToStorage('profile_images', file);

      // Save image link to Firestore
      await _firestore.collection('userProfile').doc().set({
        'imagePath': imagePath,
      }, SetOptions(merge: true)); // Merge with existing data if any

      return 'Success';
    } catch (err) {
      if (kDebugMode) {
        print('Error saving data: $err');
      }
      throw err.toString();
    }
  }
}
