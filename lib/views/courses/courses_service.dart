import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CoursesService {
  final CollectionReference _registrationsCollection =
      FirebaseFirestore.instance.collection('registrationsCourse');

  Future<void> subscribeCourse({
    required int courseId,
    required String userName,
    required String userId,
    required bool status,
  }) async {
    try {
      await _registrationsCollection.add({
        'courseId': courseId,
        'userName': userName,
        'userId': userId,
        'status': status,
        'registrationDate': DateTime.now(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error subscribing to course: $e');
      }
      rethrow;
    }
  }
}
