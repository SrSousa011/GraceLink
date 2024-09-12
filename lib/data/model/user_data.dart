import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String userId;
  final String fullName;
  final String address;
  final String imagePath;
  final String? role;

  UserData({
    required this.userId,
    required this.fullName,
    required this.address,
    required this.imagePath,
    this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'fullName': fullName,
      'address': address,
      'imagePath': imagePath,
      'role': role,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      address: json['address'] ?? '',
      imagePath: json['imagePath'] ?? '',
      role: json['role'] as String?,
    );
  }

  factory UserData.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    return UserData(
      userId: doc.id,
      fullName: data?['fullName'] ?? '',
      address: data?['address'] ?? '',
      imagePath: data?['imagePath'] ?? '',
      role: data?['role'] as String?,
    );
  }
}
