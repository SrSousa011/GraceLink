import 'package:cloud_firestore/cloud_firestore.dart';

class Donation {
  final String donationType;
  final num donationValue;
  final String fullName;
  final String photoURL;
  final Timestamp timestamp;
  final String userId;

  Donation({
    required this.donationType,
    required this.donationValue,
    required this.fullName,
    required this.photoURL,
    required this.timestamp,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'donationType': donationType,
      'donationValue': donationValue,
      'fullName': fullName,
      'photoURL': photoURL,
      'timestamp': timestamp,
      'userId': userId,
    };
  }

  factory Donation.fromMap(Map<String, dynamic> map) {
    return Donation(
      donationType: map['donationType'],
      donationValue: map['donationValue'],
      fullName: map['fullName'],
      photoURL: map['photoURL'],
      timestamp: map['timestamp'],
      userId: map['userId'],
    );
  }

  factory Donation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Ensure donationValue is converted from String to num if necessary
    num donationValue;
    if (data['donationValue'] is String) {
      donationValue =
          double.tryParse(data['donationValue']) ?? 0; // Parse to double
    } else {
      donationValue = data['donationValue'] ?? 0; // Handle as num directly
    }

    return Donation(
      userId: data['userId'],
      fullName: data['fullName'] ?? '',
      donationValue: donationValue,
      donationType: data['donationType'] ?? '',
      timestamp: data['timestamp'],
      photoURL: data['photoURL'] ?? '',
    );
  }
}
