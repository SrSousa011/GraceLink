import 'dart:async';

import 'package:flutter/foundation.dart';

class CoursesService {
  Map<String, int> courseRegistrations = {};

  Future<void> registerUser(
      String courseId, String userName, String userId) async {
    try {
      // Simulate API call or database operation to register the user
      // In a real scenario, this would involve sending data to a backend
      await _simulateAsyncOperation();

      // Check if course already has maximum registrations
      if (_isCourseFull(courseId)) {
        throw Exception('Course is already full.');
      }

      // Register the user
      _registerUserLocally(courseId);
    } catch (e) {
      if (kDebugMode) {
        print('Error registering user: $e');
      }
      rethrow; // Propagate the error to handle it in UI or logging
    }
  }

  // Simulate async operation (e.g., API call)
  Future<void> _simulateAsyncOperation() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  // Check if the course is already full
  bool _isCourseFull(String courseId) {
    return courseRegistrations.containsKey(courseId) &&
        courseRegistrations[courseId] ==
            30; // Example: Maximum of 30 registrations
  }

  // Update local registrations map
  void _registerUserLocally(String courseId) {
    courseRegistrations.update(courseId, (value) => value + 1,
        ifAbsent: () => 1);
  }
}
