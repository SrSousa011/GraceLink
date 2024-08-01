import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  final String id;
  final String fullName;
  final String address;
  final int phoneNumber;
  final String lastVisitedChurch;
  final String reasonForMembership;
  final String reference;
  final String civilStatus;

  Member({
    required this.id,
    required this.phoneNumber,
    required this.address,
    required this.lastVisitedChurch,
    required this.reasonForMembership,
    required this.reference,
    required this.fullName,
    required this.civilStatus,
  });

  factory Member.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Member(
      id: doc.id,
      fullName: data['fullName'] as String? ?? '',
      address: data['address'] as String? ?? '',
      phoneNumber: data['phoneNumber'] is int
          ? data['phoneNumber'] as int
          : int.tryParse(data['phoneNumber'] as String? ?? '') ?? 0,
      lastVisitedChurch: data['lastVisitedChurch'] as String? ?? '',
      reasonForMembership: data['reasonForMembership'] as String? ?? '',
      reference: data['reference'] as String? ?? '',
      civilStatus: data['civilStatus'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'address': address,
      'phoneNumber': phoneNumber,
      'lastVisitedChurch': lastVisitedChurch,
      'reasonForMembership': reasonForMembership,
      'reference': reference,
      'civilStatus': civilStatus,
    };
  }
}
