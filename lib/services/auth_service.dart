import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUpWithPersonalInfo({
    required String firstName,
    required String lastName,
  }) async {
    // Implement sign up with personal info
    // You can set up user profile here or store temporary data
  }

  Future<void> signUpWithDateOfBirthAndGender({
    required int? selectedDay,
    required int? selectedMonth,
    required int? selectedYear,
    required String selectedGender,
  }) async {
    // Implement sign up with date of birth and gender
    // Store these details temporarily or set up user profile
  }

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
      print('Error signing up: $error');
      throw error;
    }
  }
}
