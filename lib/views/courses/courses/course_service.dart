import 'package:cloud_firestore/cloud_firestore.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> update({
    required String courseId,
    String? courseName,
    String? description,
    String? descriptionDetails,
    String? instructor,
    double? price,
    DateTime? registrationDeadline,
    String? time,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (courseName != null) updateData['courseName'] = courseName;
      if (description != null) updateData['description'] = description;
      if (descriptionDetails != null) {
        updateData['descriptionDetails'] = descriptionDetails;
      }
      if (instructor != null) updateData['instructor'] = instructor;
      if (price != null) updateData['price'] = price;
      if (registrationDeadline != null) {
        updateData['registrationDeadline'] =
            Timestamp.fromDate(registrationDeadline);
      }
      if (time != null) updateData['time'] = time;

      await _firestore.collection('courses').doc(courseId).update(updateData);
    } catch (e) {
      throw Exception('Failed to update course: $e');
    }
  }
}
