import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/models/user_data.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> registerUser({
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
    required String address,
  }) async {
    if (email.isEmpty ||
        password.isEmpty ||
        username.isEmpty ||
        phoneNumber.isEmpty ||
        address.isEmpty) {
      return "Error: Please fill in all fields";
    }

    // Validate email and password
    String? emailError = _validateEmail(email);
    if (emailError != null) {
      return emailError;
    }

    String? passwordError = _validatePassword(password);
    if (passwordError != null) {
      return passwordError;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a UserData object
      UserData userData = UserData(
        uid: userCredential.user!.uid,
        fullName: username,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
        password: password,
      );

      // Convert UserData to JSON using its toJson method
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userData.toJson());

      return 'User $username registered successfully';
    } catch (err) {
      return "Error: ${err.toString()}";
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    // Validate email and password
    String? emailError = _validateEmail(email);
    if (emailError != null) {
      return emailError;
    }

    String? passwordError = _validatePassword(password);
    if (passwordError != null) {
      return passwordError;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        return 'User ${userCredential.user!.displayName ?? 'User'} made login successfully';
      } else {
        return 'Error: User not found';
      }
    } catch (err) {
      return "Error: ${err.toString()}";
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  String? validateEmail(String? value) {
    return _validateEmail(value);
  }

  String? validatePassword(String? value) {
    return _validatePassword(value);
  }

  Future<UserData> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return UserData.fromSnapshot(snap);
  }
}
