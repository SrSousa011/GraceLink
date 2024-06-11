import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<String?> getCurrentUserId();
  Future<String?> getCurrentUserName();

  Future<void> signOut({VoidCallback? onSignedOut});

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

  Future<bool> signUpWithEmailAndConfirmation({
    required String email,
    required String emailConfirmation,
  });
}

class AuthenticationService implements BaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> signUpWithPersonalInfo({
    required String firstName,
    required String lastName,
  }) async {
    // Implement sign-up with personal info
  }

  @override
  Future<void> signUpWithDateOfBirthAndGender({
    required int? selectedDay,
    required int? selectedMonth,
    required int? selectedYear,
    required String selectedGender,
  }) async {
    // Implement sign-up with date of birth and gender
  }

  @override
  Future<bool> signUpWithEmailAndConfirmation({
    required String email,
    required String emailConfirmation,
  }) async {
    // Validate email and email confirmation
    if (email != emailConfirmation) {
      return false;
    }
    try {
      // Implement sign-up with email and password
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: email, // Use email as password for demonstration purpose
      );
      return true;
    } catch (error) {
      // Handle any errors that occur during sign-up
      if (kDebugMode) {
        print('Error signing up: $error');
      }
      return false;
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
    } on FirebaseAuthException {
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
  Future<String?> getCurrentUserName() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(user.uid).get();
        return snapshot.get('fullName');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current user name: $e');
      }
      rethrow;
    }
  }

  @override
  Future<void> signOut({VoidCallback? onSignedOut}) async {
    await FirebaseAuth.instance.signOut();
    onSignedOut?.call();
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseAuth.instance.currentUser?.getIdToken(true);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('FirebaseAuthException during sign in: ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign in: $e');
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
