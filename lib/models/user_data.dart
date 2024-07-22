import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String id;
  final String fullName;
  final String address;
  final String imagePath;

  UserData({
    required this.id,
    required this.fullName,
    required this.address,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'address': address,
      'imagePath': imagePath,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      address: json['address'] ?? '',
      imagePath: json['imagePath'] ?? '',
    );
  }

  factory UserData.fromDocumentSnapshot(DocumentSnapshot doc) {
    // Safely cast the data from DocumentSnapshot to Map<String, dynamic>
    final data = doc.data() as Map<String, dynamic>?;
    return UserData(
      id: doc.id,
      fullName: data?['fullName'] ?? '',
      address: data?['address'] ?? '',
      imagePath: data?['imagePath'] ?? '',
    );
  }

  factory UserData.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    return UserData(
      id: doc.id,
      fullName: data?['fullName'] ?? '',
      address: data?['address'] ?? '',
      imagePath: data?['imagePath'] ?? '',
    );
  }
}
