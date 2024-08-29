import 'package:cloud_firestore/cloud_firestore.dart';

class CourseRegistration {
  final String courseId;
  final String courseName;
  final DateTime createdAt;
  final DateTime registrationDate;
  final bool status;
  final String userId;
  final String userName;

  CourseRegistration({
    required this.courseId,
    required this.courseName,
    required this.createdAt,
    required this.registrationDate,
    required this.status,
    required this.userId,
    required this.userName,
  });

  factory CourseRegistration.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final createdAtTimestamp = data['createdAt'] as Timestamp?;
    final registrationDateTimestamp = data['registrationDate'] as Timestamp?;

    return CourseRegistration(
      courseId: data['courseId'] ?? '',
      courseName: data['courseName'] ?? '',
      createdAt: createdAtTimestamp?.toDate() ?? DateTime.now(),
      registrationDate: registrationDateTimestamp?.toDate() ?? DateTime.now(),
      status: data['status'] ?? false,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'courseName': courseName,
      'createdAt': Timestamp.fromDate(createdAt),
      'registrationDate': Timestamp.fromDate(registrationDate),
      'status': status,
      'userId': userId,
      'userName': userName,
    };
  }

  CourseRegistration copyWith({
    String? courseId,
    String? courseName,
    DateTime? createdAt,
    DateTime? registrationDate,
    bool? status,
    String? userId,
    String? userName,
  }) {
    return CourseRegistration(
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      createdAt: createdAt ?? this.createdAt,
      registrationDate: registrationDate ?? this.registrationDate,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
    );
  }
}
