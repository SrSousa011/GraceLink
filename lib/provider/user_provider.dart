import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:churchapp/models/user_data.dart';

class UserProvider with ChangeNotifier {
  UserData? _user;

  UserData? get user => _user;

  void setUser(UserData userData) {
    _user = userData;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  void updateUserData(Map<String, dynamic> newData) {
    if (_user != null) {
      _user = UserData(
        uid: newData['uid'] ?? _user!.uid,
        fullName: newData['fullName'] ?? _user!.fullName,
        email: newData['email'] ?? _user!.email,
        password: newData['password'] ?? _user!.password,
        phoneNumber: newData['phoneNumber'] ?? _user!.phoneNumber,
        address: newData['address'] ?? _user!.address,
      );
      notifyListeners();
    }
  }

  Future<void> fetchUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        _user = UserData.fromDocumentSnapshot(doc);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
    }
  }
}
