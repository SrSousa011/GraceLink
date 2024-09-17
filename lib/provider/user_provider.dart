import 'package:churchapp/auth/auth_method.dart';
import 'package:churchapp/data/model/user_data.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  UserData? _user;
  final AuthMethods _authMethods = AuthMethods();

  UserData? get getUser => _user;

  Future<void> refreshUser() async {
    try {
      UserData user = await _authMethods.getUserDetails();
      _user = user;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing user: $e');
      }
    }
  }
}
