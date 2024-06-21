import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CoursesService {
  final CollectionReference _registrationsCollection =
      FirebaseFirestore.instance.collection('registrations');

  Future<void> subscribeCourse({
    required String courseId,
    required String userName,
    required String userId,
  }) async {
    try {
      await _registrationsCollection.add({
        'courseId': courseId,
        'userName': userName,
        'userId': userId,
        'timestamp': DateTime.now(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error subscribing to course: $e');
      }
      rethrow;
    }
  }
}
