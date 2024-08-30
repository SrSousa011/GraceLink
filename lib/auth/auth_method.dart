import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/data/model/user_data.dart';
import 'package:flutter/foundation.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> registerUser({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
    required String imagePath,
    required String gender,
    required String city,
    required String country,
    required int day,
    required int month,
    required int year,
  }) async {
    if (_isEmpty(email) ||
        _isEmpty(password) ||
        _isEmpty(confirmPassword) ||
        _isEmpty(firstName) ||
        _isEmpty(lastName) ||
        _isEmpty(phoneNumber) ||
        _isEmpty(address) ||
        _isEmpty(gender) ||
        _isEmpty(city) ||
        _isEmpty(country) ||
        day == 0 ||
        month == 0 ||
        year == 0) {
      return 'Please fill in all fields';
    }

    String? emailError = _validateEmail(email);
    if (emailError != null) return emailError;

    String? passwordError = _validatePassword(password);
    if (passwordError != null) return passwordError;

    String? confirmPasswordError =
        _validateConfirmPassword(password, confirmPassword);
    if (confirmPasswordError != null) return confirmPasswordError;

    String? firstNameError = validateFirstName(firstName);
    if (firstNameError != null) return firstNameError;

    String? lastNameError = validateLastName(lastName);
    if (lastNameError != null) return lastNameError;

    String? cityError = validateCity(city);
    if (cityError != null) return cityError;

    String? countryError = validateCountry(country);
    if (countryError != null) return countryError;

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserData userData = UserData(
        id: userCredential.user!.uid,
        fullName: '$firstName $lastName',
        address: address,
        imagePath: imagePath,
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userData.toJson());

      return 'User $firstName $lastName registered successfully';
    } catch (err) {
      return 'Error: ${err.toString()}';
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String? emailError = _validateEmail(email);
    if (emailError != null) return emailError;

    String? passwordError = _validatePassword(password);
    if (passwordError != null) return passwordError;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return 'User ${userCredential.user!.displayName ?? 'User'} logged in successfully';
    } catch (err) {
      return 'Error: ${err.toString()}';
    }
  }

  String? _validateEmail(String? value) {
    if (_isEmpty(value)) {
      return 'Please enter your email';
    }

    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (_isEmpty(value)) {
      return 'Please enter your password';
    }

    if (value!.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  String? _validateConfirmPassword(String password, String confirmPassword) {
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateEmail(String? value) {
    return _validateEmail(value);
  }

  String? validatePassword(String? value) {
    return _validatePassword(value);
  }

  String? validateFirstName(String? value) {
    if (_isEmpty(value)) {
      return 'First Name cannot be empty';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (_isEmpty(value)) {
      return 'Last Name cannot be empty';
    }
    return null;
  }

  String? validateCity(String? value) {
    if (_isEmpty(value)) {
      return 'City cannot be empty';
    }
    return null;
  }

  String? validateCountry(String? value) {
    if (_isEmpty(value)) {
      return 'Country cannot be empty';
    }
    return null;
  }

  bool _isEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  Future<UserData> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return UserData.fromDocument(snap);
  }

  Future<bool> checkIfEmailExists(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking email existence: $e');
      }
      return false;
    }
  }
}


