import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String fullName;
  final String email;
  final String password;
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
      'fullname': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'address': address,
    };
  }

  static UserData fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return UserData(
      uid: data['uid'] ?? '',
      fullName: data['fullname'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
    );
  }
}
