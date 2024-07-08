import 'package:churchapp/views/events/event_service.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/models/user_data.dart';

class UserProvider with ChangeNotifier {
  UserData? _user;
  Event? _currentEvent;

  UserData? get user => _user;
  Event? get currentEvent => _currentEvent;

  void setUser(UserData userData) {
    _user = userData;
    _currentEvent = null;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _currentEvent = null; // Clear current event when clearing user
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
      // Handle error accordingly in production mode
    }
  }

  void updateEvent(Event event) {
    _currentEvent = event;
    notifyListeners();
  }
}
