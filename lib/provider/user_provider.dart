import 'package:churchapp/data/model/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:churchapp/views/events/event_service.dart';

class UserProvider with ChangeNotifier {
  UserData? _user;
  Event? _currentEvent;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserData? get user => _user;
  Event? get currentEvent => _currentEvent;

  void setUser(UserData userData) {
    _user = userData;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  Future<UserData?> getCurrentUserData() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(user.uid).get();
        if (snapshot.exists) {
          return UserData.fromDocument(snapshot);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user data: $e');
      }
      return null;
    }
  }

  void updateEvent(Event event) {
    _currentEvent = event;
    notifyListeners();
  }
}
