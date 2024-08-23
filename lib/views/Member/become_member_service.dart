import 'package:cloud_firestore/cloud_firestore.dart';

class BecomeMemberService {
  final CollectionReference _memberCollection =
      FirebaseFirestore.instance.collection('becomeMember');

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
  }) async {
    try {
      final age = DateTime.now().year - birthDate!.year;

      await _memberCollection.add({
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
        'birthDate': Timestamp.fromDate(birthDate),
        'age': age,
      });
    } catch (e) {
      throw Exception('Failed to add member: $e');
    }
  }
}
