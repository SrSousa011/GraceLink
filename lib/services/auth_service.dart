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

  Future<void> sendEmailVerification();

  Future<bool> isEmailVerified();

  Future<void> deleteUser();

  Future<void> sendPasswordResetMail(String email);

  Future<void> changeEmail(String email);

  Future<void> changePassword(String password);

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
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
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
      await _firebaseAuth.createUserWithEmailAndPassword(
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
      return await _firebaseAuth.createUserWithEmailAndPassword(
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
      User? user = _firebaseAuth.currentUser;
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
      User? user = _firebaseAuth.currentUser;
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
    await _firebaseAuth.signOut();
    onSignedOut?.call();
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firebaseAuth.currentUser?.getIdToken(true);
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
    User? user = _firebaseAuth.currentUser;
    return user != null;
  }

  @override
  Future<void> sendEmailVerification() async {
    User? user = _firebaseAuth.currentUser;
    await user?.sendEmailVerification();
  }

  @override
  Future<bool> isEmailVerified() async {
    User? user = _firebaseAuth.currentUser;
    return user?.emailVerified ?? false;
  }

  @override
  Future<void> changeEmail(String email) async {
    User? user = _firebaseAuth.currentUser;
    try {
      await user?.verifyBeforeUpdateEmail(email);
      if (kDebugMode) {
        print("Successfully changed email");
      }
    } catch (error) {
      if (kDebugMode) {
        print("Email can't be changed: ${error.toString()}");
      }
    }
  }

  @override
  Future<void> changePassword(String password) async {
    User? user = _firebaseAuth.currentUser;
    try {
      await user?.updatePassword(password);
      if (kDebugMode) {
        print("Successfully changed password");
      }
    } catch (error) {
      if (kDebugMode) {
        print("Password can't be changed: ${error.toString()}");
      }
    }
  }

  @override
  Future<void> deleteUser() async {
    User? user = _firebaseAuth.currentUser;
    try {
      await user?.delete();
      if (kDebugMode) {
        print("Successfully deleted user");
      }
    } catch (error) {
      if (kDebugMode) {
        print("User can't be deleted: ${error.toString()}");
      }
    }
  }

  @override
  Future<void> sendPasswordResetMail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      await user?.delete();
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}
