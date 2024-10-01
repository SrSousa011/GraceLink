class CourseRegistration {
  final String courseId;
  final String courseName;
  final DateTime createdAt;
  final DateTime registrationDate;
  final bool status;
  final double price;
  final String userId;
  final String userName;

  CourseRegistration({
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
