import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:churchapp/models/user_data.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> registerUser({
    required String email,
    required String bio,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String address,
    required String imagePath,
  }) async {
    if (_isEmpty(email) ||
        _isEmpty(password) ||
        _isEmpty(firstName) ||
        _isEmpty(lastName) ||
        _isEmpty(phoneNumber) ||
        _isEmpty(address)) {
      return 'Please fill in all fields';
    }

    String? emailError = _validateEmail(email);
    if (emailError != null) {
      return emailError;
    }

    String? passwordError = _validatePassword(password);
    if (passwordError != null) {
      return passwordError;
    }

    String? firstNameError =
        validateFirstName(firstName); // Using the public method here
    if (firstNameError != null) {
      return firstNameError;
    }

    String? lastNameError =
        validateLastName(lastName); // Using the public method here
    if (lastNameError != null) {
      return lastNameError;
    }

    String? validatePhoneNumberError =
        validatePhoneNumber(phoneNumber); // Using the public method here
    if (validatePhoneNumberError != null) {
      return validatePhoneNumberError;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserData userData = UserData(
        id: userCredential.user!.uid,
        fullName: '$firstName $lastName',
        bio: bio,
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
        return 'User ${userCredential.user!.displayName ?? 'User'} logged in successfully';
      } else {
        return 'Error: User not found';
      }
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

  String? validateEmail(String? value) {
    return _validateEmail(value);
  }

  String? validatePassword(String? value) {
    return _validatePassword(value);
  }

  String? validateFirstName(String? value) {
    // Making this method public
    if (_isEmpty(value)) {
      return 'First Name cannot be empty';
    }
    return null;
  }

  String? validateLastName(String? value) {
    // Making this method public
    if (_isEmpty(value)) {
      return 'Last Name cannot be empty';
    }
    return null;
  }

  String? validatePhoneNumber(String value) {
    // Making this method public
    if (_isEmpty(value)) {
      return 'Phone number cannot be empty';
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
    return UserData.fromDocumentSnapshot(snap);
  }
}
