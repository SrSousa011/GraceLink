import 'package:churchapp/models/user_data.dart';
import 'package:churchapp/services/auth_method.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserData? _user;
  final AuthMethods _authMethods = AuthMethods();

  UserData? get getUser => _user;

  Future<void> refreshUser() async {
    UserData user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
