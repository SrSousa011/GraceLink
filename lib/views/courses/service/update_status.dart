import 'package:cloud_firestore/cloud_firestore.dart';

class StatusUpdater {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateStatus(String userId, String status) async {
    // Create a reference to the document
    final docRef = _firestore.collection('courseregistration').doc(userId);

    // Print the document reference and userId for debugging
    print('Document Reference: ${docRef.path}');
    print('User ID: $userId');

    // Get the document snapshot
    final docSnapshot = await docRef.get();

    // Print document existence and data
    print('Status: ${docSnapshot.exists}');
    if (docSnapshot.exists) {
      print('Document Data: ${docSnapshot.data()}');
    } else {
      return;
    }

    // Print status before update
    print('Status before update: ${docSnapshot.data()?['status']}');

    // Update the status field
    await docRef.update({
      'status': status,
    });

    // Confirm successful update
    print('Document successfully updated');

    // Verify status after update
    final updatedDocSnapshot = await docRef.get();
    print('Status after update: ${updatedDocSnapshot.data()?['status']}');
  }
}
