import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

abstract class BaseAuth {
  Future<UserCredential> createUserWithEmailAndPassword(
      {required String email, required String password});

  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<String?> getCurrentUserId();

  Future<void> signOut();

  Future<bool> isLoggedIn();

  // New methods for signing up
  Future<void> signUpWithPersonalInfo({
    required String firstName,
    required String lastName,
  });

  Future<void> signUpWithDateOfBirthAndGender({
    required int? selectedDay,
    required int? selectedMonth,
    required int? selectedYear,
    required String selectedGender,
  });

  Future<void> signUpWithEmailAndConfirmation({
    required String email,
    required String emailConfirmation,
  });
}

class AuthenticationService implements BaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> signUpWithPersonalInfo({
    required String firstName,
    required String lastName,
  }) async {}

  @override
  Future<void> signUpWithDateOfBirthAndGender({
    required int? selectedDay,
    required int? selectedMonth,
    required int? selectedYear,
    required String selectedGender,
  }) async {}

  @override
  Future<void> signUpWithEmailAndConfirmation({
    required String email,
    required String emailConfirmation,
  }) async {
    // Implement sign up with email and confirmation
    // Validate email and email confirmation
    if (email != emailConfirmation) {
      throw Exception('Emails do not match');
    }
    // Store email temporarily or proceed with Firebase authentication
  }

  Future<void> signUpWithPassword({
    required String email,
    required String password,
  }) async {
    // Implement sign up with email and password
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (error) {
      // Handle any errors that occur during sign up
      if (kDebugMode) {
        print('Error signing up: $error');
      }
      rethrow;
    }
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> getCurrentUserId() async {
    try {
      User? user = _auth.currentUser;
      return user?.uid;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current user ID: $e');
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    // Implement signOut method
    try {
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
      rethrow;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    User? user = _auth.currentUser;
    return user != null;
  }
}
