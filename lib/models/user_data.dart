import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String id;
  final String fullName;
  final String bio;
  final String imagePath;

  UserData({
    required this.id,
    required this.fullName,
    required this.bio,
    required this.imagePath,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'bio': bio,
      'imageUrl': imagePath,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      fullName: json['fullName'],
      bio: json['bio'],
      imagePath: json['imageUrl'],
    );
  }

  factory UserData.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserData(
      id: doc.id,
      fullName: data['fullName'],
      bio: data['bio'],
      imagePath: data['imageUrl'],
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'id': id,
      'fullName': fullName,
      'bio': bio,
      'imageUrl': imagePath,
    };
  }
}
