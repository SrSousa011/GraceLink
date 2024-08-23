import 'package:cloud_firestore/cloud_firestore.dart';

class BecomeMemberService {
  final CollectionReference _memberCollection =
      FirebaseFirestore.instance.collection('becomeMember');

  Future<void> addMember({
    required String fullName,
    String? address,
    String? phoneNumber,
    String? lastVisitedChurch,
    required String reasonForMembership,
    String? reference,
    String? civilStatus,
    required String gender,
    required DateTime membershipDate,
    required String createdById,
  }) async {
    try {
      await _memberCollection.add({
        'fullName': fullName,
        'address': address,
        'phoneNumber': phoneNumber,
        'lastVisitedChurch': lastVisitedChurch,
        'reasonForMembership': reasonForMembership,
        'reference': reference,
        'civilStatus': civilStatus,
        'gender': gender,
        'membershipDate': membershipDate,
        'createdById': createdById,
        'createdAt': Timestamp.fromDate(membershipDate),
      });
    } catch (e) {
      throw Exception('Failed to add member: $e');
    }
  }
}
