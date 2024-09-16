import 'package:cloud_firestore/cloud_firestore.dart';

class BecomeMemberService {
  final CollectionReference _memberCollection =
      FirebaseFirestore.instance.collection('members');

  Future<void> addMember({
    required String fullName,
    String? address,
    String? phoneNumber,
    DateTime? birthDate,
    String? lastVisitedChurch,
    required String reasonForMembership,
    String? reference,
    String? civilStatus,
    required DateTime membershipDate,
    required String createdById,
    required String gender,
    DateTime? baptismDate,
    DateTime? conversionDate,
  }) async {
    try {
      final memberData = {
        'fullName': fullName,
        'address': address,
        'phoneNumber': phoneNumber,
        'lastVisitedChurch': lastVisitedChurch,
        'reasonForMembership': reasonForMembership,
        'reference': reference,
        'civilStatus': civilStatus,
        'membershipDate': membershipDate,
        'createdById': createdById,
        'createdAt': Timestamp.fromDate(membershipDate),
        'gender': gender,
        'birthDate': birthDate != null ? Timestamp.fromDate(birthDate) : null,
      };

      if (baptismDate != null) {
        memberData['baptismDate'] = Timestamp.fromDate(baptismDate);
      }
      if (conversionDate != null) {
        memberData['conversionDate'] = Timestamp.fromDate(conversionDate);
      }

      await _memberCollection.add(memberData);
    } catch (e) {
      throw Exception('Failed to add member: $e');
    }
  }
}
