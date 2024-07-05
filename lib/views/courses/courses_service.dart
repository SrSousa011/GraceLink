import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CoursesService {
  final CollectionReference _registrationsCollection =
      FirebaseFirestore.instance.collection('courseregistration');

  Future<bool> isUserAlreadySubscribed({
    required int courseId,
    required String userId,
  }) async {
    try {
      QuerySnapshot querySnapshot = await _registrationsCollection
          .where('courseId', isEqualTo: courseId)
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking user subscription: $e');
      }
      rethrow;
    }
  }

  Future<void> registerUserForCourse({
    required int courseId,
    required String userId,
    required String userName,
    required bool status,
  }) async {
    try {
      await _registrationsCollection.add({
        'courseId': courseId,
        'userId': userId,
        'userName': userName,
        'status': status,
        'registrationDate': DateTime.now(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error registering user for course: $e');
      }
      rethrow;
    }
  }
}
