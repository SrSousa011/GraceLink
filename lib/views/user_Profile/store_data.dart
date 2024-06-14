import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      print('Error uploading image to storage: $err');
      throw err.toString();
    }
  }

  Future<String> saveData({required Uint8List file}) async {
    try {
      String imageUrl = await uploadImageToStorage('ProfileImage', file);
      await _firestore.collection("userProfile").add({
        'imageLink': imageUrl,
      });
      return 'Success';
    } catch (err) {
      print('Error saving data to Firestore: $err');
      throw err.toString();
    }
  }

  Future<String> getProfileImage() async {
    try {
      // Replace with the correct path to your ProfileImage in Firebase Storage
      String downloadURL =
          await _storage.ref().child('ProfileImage').getDownloadURL();
      return downloadURL;
    } catch (err) {
      print('Error getting profile image from storage: $err');
      throw err.toString();
    }
  }
}
