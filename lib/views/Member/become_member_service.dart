import 'package:cloud_firestore/cloud_firestore.dart';

class BecomeMemberService {
  final CollectionReference _memberCollection =
      FirebaseFirestore.instance.collection('becomeMember');

  Future<void> addMember({
    required String fullName,
    required String address,
    required String lastVisitedChurch,
    required String reasonForMembership,
    required String reference,
    required String civilStatus,
  }) async {
    try {
      await _memberCollection.add({
        'fullName': fullName,
        'address': address,
        'lastVisitedChurch': lastVisitedChurch,
        'reasonForMembership': reasonForMembership,
        'reference': reference,
        'civilStatus': civilStatus,
      });
    } catch (e) {
      throw Exception('Failed to add member: $e');
    }
  }
}
