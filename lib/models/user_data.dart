import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String id;
  final String fullName;
  final String address;
  final String imagePath;
  final String? role;

  UserData({
    required this.id,
    required this.fullName,
    required this.address,
    required this.imagePath,
    this.role,
  });

  // Convert to JSON format for Firestore storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'address': address,
      'imagePath': imagePath,
      'role': role, // Add role to JSON output
    };
  }

  // Create a UserData instance from JSON data
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      address: json['address'] ?? '',
      imagePath: json['imagePath'] ?? '',
      role: json['role'] as String?,
    );
  }

  factory UserData.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserData(
      id: doc.id,
      fullName: data['fullName'] ?? '',
      address: data['address'] ?? '',
      imagePath: data['imagePath'] ?? '',
      role: data['role'] as String?,
    );
  }
}
