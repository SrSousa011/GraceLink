import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String fullName;
  final String email;
  final String password; // Consider using hashed passwords
  final String phoneNumber;
  final String address;

  UserData({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      uid: json['uid'],
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
    );
  }

  factory UserData.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserData(
      uid: data['uid'],
      fullName: data['fullName'],
      email: data['email'],
      password: data['password'],
      phoneNumber: data['phoneNumber'],
      address: data['address'],
    );
  }

  Map<String, dynamic> toDocumentSnapshot() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }
}
