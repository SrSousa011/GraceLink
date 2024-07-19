import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateUserProfile(
      String userId, String fullName, String address) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'fullName': fullName,
        'address': address, // Atualizado para salvar o endereço
      });
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
