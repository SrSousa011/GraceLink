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

  Future<void> uploadAndSaveImage({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        onError("No image selected.");
        return;
      }

      File file = File(pickedFile.path);
      if (!await file.exists()) {
        onError("Selected file does not exist.");
        return;
      }

      String fileName = path.basename(file.path);
      String uniqueFileName =
          '${DateTime.now().millisecondsSinceEpoch}_$fileName';

      final uploadTask =
          _storage.ref().child('eventImages/$uniqueFileName').putFile(file);

      final taskSnapshot = await uploadTask;

      final downloadURL = await taskSnapshot.ref.getDownloadURL();

      await _firestore
          .collection('events')
          .doc(eventId)
          .update({'imageUrl': downloadURL});

      if (kDebugMode) {
        print('Image uploaded successfully: $downloadURL');
      }

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

      onError(errorMessage);
    }
  }
}
