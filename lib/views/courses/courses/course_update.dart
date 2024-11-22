import 'package:cloud_firestore/cloud_firestore.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> update({
    required String courseId,
    String? courseName,
    String? description,
    String? descriptionDetails,
    String? instructor,
    double? price, // Price as double in Dart
    DateTime? registrationDeadline,
    DateTime? time,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      // Update fields only if they are not null
      if (courseName != null) updateData['courseName'] = courseName;
      if (description != null) updateData['description'] = description;
      if (descriptionDetails != null) {
        updateData['descriptionDetails'] = descriptionDetails;
      }
      if (instructor != null) updateData['instructor'] = instructor;
      if (price != null) {
        updateData['price'] = price; // Store as a number in Firestore
      }
      if (registrationDeadline != null) {
        updateData['registrationDeadline'] =
            Timestamp.fromDate(registrationDeadline);
      }
      if (time != null) {
        updateData['time'] = Timestamp.fromDate(time);
      }

      // Update the document in Firestore
      await _firestore.collection('courses').doc(courseId).update(updateData);
    } catch (e) {
      throw Exception('Failed to update course: $e');
    }
  }

  // Method to fetch course price based on courseId
  Future<double?> getPrice(String courseId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('courses').doc(courseId).get();
      if (doc.exists) {
        // Retrieve price as a number and cast to double
        return (doc.data() as Map<String, dynamic>)['price']?.toDouble();
      } else {
        throw Exception('Course not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch course price: $e');
    }
  }

  // Fetch course registrations and include course price
  Future<List<CourseRegistrationWithPrice>>
      fetchRegistrationsWithPrice() async {
    List<CourseRegistrationWithPrice> registrationsWithPrice = [];
    try {
      QuerySnapshot registrationSnapshot =
          await _firestore.collection('courseRegistration').get();

      for (var doc in registrationSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Extract the courseId to fetch the price
        String courseId = data['courseId'];
        double? price = await getPrice(courseId); // Fetch price from courses

        // Create a registration object with price
        CourseRegistrationWithPrice registration = CourseRegistrationWithPrice(
          courseId: courseId,
          courseName: data['courseName'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
          registrationDate: (data['registrationDate'] as Timestamp).toDate(),
          status: data['status'],
          price: price ?? 0.0, // Default to 0.0 if price is null
          userId: data['userId'],
          userName: data['userName'],
        );

        registrationsWithPrice.add(registration);
      }
    } catch (e) {
      throw Exception('Failed to fetch registrations: $e');
    }
    return registrationsWithPrice;
  }
}

// Define a class for course registrations with price
class CourseRegistrationWithPrice {
  final String courseId;
  final String courseName;
  final DateTime createdAt;
  final DateTime registrationDate;
  final bool status;
  final double price; // Price included
  final String userId;
  final String userName;

  CourseRegistrationWithPrice({
    required this.courseId,
    required this.courseName,
    required this.createdAt,
    required this.registrationDate,
    required this.status,
    required this.price,
    required this.userId,
    required this.userName,
  });
}
