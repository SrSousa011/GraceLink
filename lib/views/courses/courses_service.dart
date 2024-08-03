import 'package:churchapp/views/courses/courses_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CoursesService {
  final CollectionReference _registrationsCollection =
      FirebaseFirestore.instance.collection('courseregistration');

  // Check if a user is already subscribed to a specific course
  Future<bool> isUserAlreadySubscribed({
    required String courseId,
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

  // Fetch a list of courses from Firestore
  Future<List<Course>> getCourses() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('courses').get();
      return querySnapshot.docs.map((doc) {
        return Course.fromDocument(doc);
      }).toList();
    } catch (e) {
      print('Error fetching courses: $e');
      throw e;
    }
  }

  // Register a user for a course
  Future<void> registerUserForCourse({
    required String courseId,
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
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error registering user for course: $e');
      }
      rethrow;
    }
  }

  // Update the status of a user for a specific course
  Future<void> updateUserStatus({
    required String userId,
    required String courseId,
    required bool status,
  }) async {
    try {
      final querySnapshot = await _registrationsCollection
          .where('userId', isEqualTo: userId)
          .where('courseId', isEqualTo: courseId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final docId = querySnapshot.docs.first.id;
        await _registrationsCollection.doc(docId).update({
          'status': status,
        });
      } else {
        if (kDebugMode) {
          print(
              'No registration found for userId: $userId and courseId: $courseId');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user status: $e');
      }
      rethrow;
    }
  }
}
