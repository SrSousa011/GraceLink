import 'package:churchapp/views/courses/service/courses_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CoursesService {
  final CollectionReference _registrationsCollection =
      FirebaseFirestore.instance.collection('courseRegistration');

  Future<bool> isUserAlreadySubscribed({
    required String courseId,
    required String userId,
  }) async {
    try {
      if (kDebugMode) {
        print('Checking subscription for userId: $userId, courseId: $courseId');
      }

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

  Future<bool> isCourseAlreadyPaid({
    required String courseId,
    required String userId,
  }) async {
    try {
      if (courseId.isEmpty || userId.isEmpty) {
        return false; // or throw an exception if appropriate
      }

      QuerySnapshot querySnapshot = await _registrationsCollection
          .where('courseId', isEqualTo: courseId)
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return false;
      }

      var doc = querySnapshot.docs.first;
      bool status = doc['status'] as bool;

      return status;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changeStatus({
    required String courseId,
    required String userId,
  }) async {
    try {
      if (courseId.isEmpty || userId.isEmpty) {
        throw Exception('Course ID or User ID is empty');
      }

      QuerySnapshot querySnapshot = await _registrationsCollection
          .where('courseId', isEqualTo: courseId)
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No registration found for the given user and course.');
      }

      var doc = querySnapshot.docs.first;
      bool currentStatus = doc['status'] as bool;

      await _registrationsCollection.doc(doc.id).update({
        'status': !currentStatus,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Course>> getCourses() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('courses').get();
      return querySnapshot.docs.map((doc) {
        return Course.fromDocument(doc);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching courses: $e');
      }
      rethrow;
    }
  }

  Future<void> registerUserForCourse({
    required String courseId,
    required String courseName,
    required String userId,
    required String userName,
    required bool status,
  }) async {
    try {
      if (kDebugMode) {
        print('Registering userId: $userId for courseId: $courseId');
      }

      await _registrationsCollection.add({
        'courseId': courseId,
        'courseName': courseName,
        'userId': userId,
        'userName': userName,
        'status': status,
        'registrationDate': DateTime.now(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error registering user for course: $e');
      }
      rethrow;
    }
  }
}
