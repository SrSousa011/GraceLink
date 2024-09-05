import 'package:churchapp/views/courses/service/courses_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CoursesService {
  final CollectionReference _registrationsCollection =
      FirebaseFirestore.instance.collection('courseRegistration');
  final CollectionReference _coursesCollection =
      FirebaseFirestore.instance.collection('courses');

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
        return false;
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
      final querySnapshot = await _coursesCollection.get();
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

  Future<int> getUserCountForCourse(String courseId) async {
    try {
      if (kDebugMode) {
        print('Counting users for courseId: $courseId');
      }

      QuerySnapshot querySnapshot = await _registrationsCollection
          .where('courseId', isEqualTo: courseId)
          .get();

      return querySnapshot.docs.length;
    } catch (e) {
      if (kDebugMode) {
        print('Error counting users for course: $e');
      }
      rethrow;
    }
  }

  Future<double> calculateTotalRevenue() async {
    try {
      if (kDebugMode) {
        print('Calculating total revenue');
      }

      final coursesSnapshot = await _coursesCollection.get();
      final courses = coursesSnapshot.docs;

      double totalRevenue = 0.0;

      for (var courseDoc in courses) {
        final courseId = courseDoc.id;
        final data = courseDoc.data() as Map<String, dynamic>?;
        final price = data?['price'] as num?;

        final coursePrice =
            (price is int) ? price.toDouble() : (price?.toDouble() ?? 0.0);

        final registrationsSnapshot = await _registrationsCollection
            .where('courseId', isEqualTo: courseId)
            .where('status', isEqualTo: true)
            .get();

        totalRevenue += registrationsSnapshot.docs.length * coursePrice;
      }

      return totalRevenue;
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating total revenue: $e');
      }
      rethrow;
    }
  }

  Future<double> calculateMonthlyRevenue() async {
    try {
      if (kDebugMode) {
        print('Calculating monthly revenue');
      }

      final coursesSnapshot = await _coursesCollection.get();
      final courses = coursesSnapshot.docs;

      double monthlyRevenue = 0.0;
      DateTime now = DateTime.now();
      DateTime startOfMonth = DateTime(now.year, now.month, 1);
      DateTime endOfMonth = DateTime(now.year, now.month + 1, 1)
          .subtract(const Duration(days: 1));

      for (var courseDoc in courses) {
        final courseId = courseDoc.id;
        final data = courseDoc.data() as Map<String, dynamic>?;
        final price = data?['price'] as num?;
        final coursePrice =
            (price is int) ? price.toDouble() : (price?.toDouble() ?? 0.0);

        final registrationsSnapshot = await _registrationsCollection
            .where('courseId', isEqualTo: courseId)
            .where('status', isEqualTo: true)
            .get();

        final newEnrolled = registrationsSnapshot.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          final registrationDate = data?['registrationDate'] as Timestamp?;
          if (registrationDate == null) return false;
          final date = registrationDate.toDate();
          return date.isAfter(startOfMonth) && date.isBefore(endOfMonth);
        }).length;

        monthlyRevenue += newEnrolled * coursePrice;
      }

      return monthlyRevenue;
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating monthly revenue: $e');
      }
      rethrow;
    }
  }

  Future<double> calculateAnnualRevenue() async {
    try {
      if (kDebugMode) {
        print('Calculating annual revenue');
      }

      final coursesSnapshot = await _coursesCollection.get();
      final courses = coursesSnapshot.docs;

      double annualRevenue = 0.0;
      DateTime now = DateTime.now();
      DateTime startOfYear = DateTime(now.year, 1, 1);
      DateTime endOfYear =
          DateTime(now.year + 1, 1, 1).subtract(const Duration(days: 1));

      for (var courseDoc in courses) {
        final courseId = courseDoc.id;
        final data = courseDoc.data() as Map<String, dynamic>?;
        final price = data?['price'] as num?;
        final coursePrice =
            (price is int) ? price.toDouble() : (price?.toDouble() ?? 0.0);

        final registrationsSnapshot = await _registrationsCollection
            .where('courseId', isEqualTo: courseId)
            .where('status', isEqualTo: true)
            .get();

        final enrolledForYear = registrationsSnapshot.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          final registrationDate = data?['registrationDate'] as Timestamp?;
          if (registrationDate == null) return false;
          final date = registrationDate.toDate();
          return date.isAfter(startOfYear) && date.isBefore(endOfYear);
        }).length;

        annualRevenue += enrolledForYear * coursePrice;
      }

      return annualRevenue;
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating annual revenue: $e');
      }
      rethrow;
    }
  }
}
