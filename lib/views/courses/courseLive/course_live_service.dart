import 'package:cloud_firestore/cloud_firestore.dart';

class CourseLiveService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> update(String courseId, String time, String daysOfWeek) async {
    try {
      await _firestore.collection('courses').doc(courseId).update({
        'time': time,
        'daysOfWeek': daysOfWeek,
      });
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
