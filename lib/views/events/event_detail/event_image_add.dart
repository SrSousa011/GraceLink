import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageAdd {
  final FirebaseStorage _storage;
  final FirebaseFirestore _firestore;
  final ImagePicker _picker;
  final String eventId;

  ImageAdd({
    required FirebaseStorage storage,
    required FirebaseFirestore firestore,
    required ImagePicker picker,
    required this.eventId,
  })  : _storage = storage,
        _firestore = firestore,
        _picker = picker;

  Future<String?> updateImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        final imageBytes = await file.readAsBytes();

        String fileName = path.basename(file.path);
        String uniqueFileName =
            '${DateTime.now().millisecondsSinceEpoch}_$fileName';

        final uploadTask = _storage
            .ref()
            .child('eventImages/$uniqueFileName')
            .putData(imageBytes);
        final taskSnapshot = await uploadTask;

        final downloadUrl = await taskSnapshot.ref.getDownloadURL();
        if (kDebugMode) {
          print('Image uploaded successfully: $downloadUrl');
        }

        await _firestore
            .collection('events')
            .doc(eventId)
            .update({'imageUrl': downloadUrl});

        return downloadUrl;
      } else {
        return null;
      }
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
        print("Error selecting or uploading image: $errorMessage");
      }
      return null;
    }
  }
}
