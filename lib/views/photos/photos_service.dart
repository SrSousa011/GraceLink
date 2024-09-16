import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchapp/data/model/photos_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class PhotosService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  Future<List<String>> uploadImages(List<XFile> files, String location) async {
    final uploadId = DateTime.now().millisecondsSinceEpoch.toString();
    final List<String> imageUrls = [];

    try {
      for (final file in files) {
        final fileName =
            '${path.basenameWithoutExtension(file.path)}_$location${path.extension(file.path)}';
        final fileData = await file.readAsBytes();
        final storageRef = _storage.ref().child('photos/$fileName/$uploadId');

        final uploadTask = storageRef.putData(Uint8List.fromList(fileData));
        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();

        imageUrls.add(downloadUrl);
      }
      return imageUrls;
    } catch (e) {
      throw Exception('Error uploading images: $e');
    }
  }

  Future<void> savePhotoData(String location, List<String> imageUrls) async {
    final locationDocRef = _firestore.collection('photos').doc(location);

    try {
      await locationDocRef.set({
        'location': location,
        'uploadId': DateTime.now().millisecondsSinceEpoch.toString(),
        'createdAt': Timestamp.now(),
        'urls': imageUrls,
      });
    } catch (e) {
      throw Exception('Error saving photo data: $e');
    }
  }

  Future<void> deletePhotoData(String location) async {
    final locationDocRef = _firestore.collection('photos').doc(location);

    try {
      final doc = await locationDocRef.get();
      if (doc.exists) {
        final data = doc.data();
        final urls = List<String>.from(data?['urls'] ?? []);

        for (final url in urls) {
          final ref = _storage.refFromURL(url);
          await ref.delete();
        }

        await locationDocRef.delete();
      }
    } catch (e) {
      throw Exception('Error deleting photo data: $e');
    }
  }

  Future<List<XFile>?> pickMultipleImages() async {
    return await _picker.pickMultiImage();
  }

  Future<XFile?> pickSingleImage() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  Future<XFile?> pickImageFromCamera() async {
    return await _picker.pickImage(source: ImageSource.camera);
  }

  Stream<List<PhotoData>> getPhotosWithLocationsStream() {
    return _firestore
        .collection('photos')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return PhotoData(
          urls: List<String>.from(data['urls'] ?? []),
          uploadId: doc.id,
          location: data['location'] ?? '',
          createdAt: data['createdAt'] as Timestamp,
        );
      }).toList();
    });
  }

  Future<ImageProvider> getPhoto(String url) async {
    return CachedNetworkImageProvider(url);
  }
}
