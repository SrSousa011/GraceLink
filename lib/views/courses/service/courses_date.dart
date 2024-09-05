import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String courseId;
  final String courseName;
  final String instructor;
  final String imageURL;
  final String description;
  final double price;
  final DateTime registrationDeadline;
  final String descriptionDetails;
  final Timestamp? time;
  final String? videoUrl;
  final String? daysOfWeek;

  Course({
    required this.courseId,
    required this.courseName,
    required this.instructor,
    required this.imageURL,
    required this.description,
    required this.price,
    required this.registrationDeadline,
    required this.descriptionDetails,
    this.time,
    this.videoUrl,
    this.daysOfWeek,
  });

  factory Course.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final timestamp = data['registrationDeadline'] as Timestamp?;
    final registrationDeadline = timestamp?.toDate() ?? DateTime.now();

    return Course(
      courseId: doc.id,
      courseName: data['courseName'] ?? '',
      instructor: data['instructor'] ?? '',
      imageURL: data['imageURL'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] as num).toDouble(),
      registrationDeadline: registrationDeadline,
      descriptionDetails: data['descriptionDetails'] ?? '',
      time: data['time'] as Timestamp?,
      videoUrl: data['videoUrl'] as String?,
      daysOfWeek: data['daysOfWeek'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseName': courseName,
      'instructor': instructor,
      'imageURL': imageURL,
      'description': description,
      'price': price,
      'registrationDeadline': Timestamp.fromDate(registrationDeadline),
      'descriptionDetails': descriptionDetails,
      'time': time,
      'videoUrl': videoUrl,
      'daysOfWeek': daysOfWeek,
    };
  }

  String getFormattedTime() {
    if (time == null) return 'No time set';
    final dateTime = time!.toDate();
    return '${dateTime.hour}:${dateTime.minute}';
  }
}
