import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String id;
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final String address;
  final String imageUrl;

  UserData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.address,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': id,
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['uid'],
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      imageUrl: json['url'],
    );
  }

  factory UserData.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserData(
      id: doc.id,
      fullName: data['fullName'],
      email: data['email'],
      password: data['password'],
      phoneNumber: data['phoneNumber'],
      address: data['address'],
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'uid': id,
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }
}
