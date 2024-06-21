import 'package:churchapp/views/member/become_member.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference _memberCollection =
      FirebaseFirestore.instance.collection('becomeMember');

  Future<void> addMember(Member member) async {
    try {
      await _memberCollection.add({
        'fullName': member.fullName,
        'address': member.address,
        'phoneNumber': member.phoneNumber,
        'lastVisitedChurch': member.lastVisitedChurch,
        'reasonForMembership': member.reasonForMembership,
        'reference': member.reference,
      });
    } catch (e) {
      throw Exception('Failed to add member: $e');
    }
  }
}
