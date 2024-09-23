import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String userId;
  final String fullName;
  final String address;
  final String photoUrl;
  final String? role;
  final String? phoneNumber;
  final DateTime? dateOfBirth;

  UserData({
    required this.userId,
    required this.fullName,
    required this.address,
    required this.photoUrl,
    this.role,
    this.phoneNumber,
    this.dateOfBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'address': address,
      'imagePath': photoUrl,
      'role': role,
      'phoneNumber': phoneNumber,
      'dateOfBirth':
          dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      address: json['address'] ?? '',
      photoUrl: json['imagePath'] ?? '',
      role: json['role'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? (json['dateOfBirth'] as Timestamp).toDate()
          : null,
    );
  }

  factory UserData.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    return UserData(
      userId: doc.id,
      fullName: data?['fullName'] ?? '',
      address: data?['address'] ?? '',
      photoUrl: data?['imagePath'] ?? '',
      role: data?['role'] as String?,
      phoneNumber: data?['phoneNumber'] as String?,
      dateOfBirth: data?['dateOfBirth'] != null
          ? (data?['dateOfBirth'] as Timestamp).toDate()
          : null,
    );
  }
}
