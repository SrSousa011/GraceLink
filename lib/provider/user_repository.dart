import 'package:churchapp/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserData> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("Users").where("email", isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      throw Exception('User not found');
    }
    final userData = snapshot.docs.map((e) => UserData.fromDocument(e)).single;
    return userData;
  }

  /// Fetch all users
  Future<List<UserData>> allUser() async {
    final snapshot = await _db.collection("Users").get();
    final userData =
        snapshot.docs.map((e) => UserData.fromDocument(e)).toList();
    return userData;
  }
}
