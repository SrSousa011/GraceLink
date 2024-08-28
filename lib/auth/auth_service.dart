import 'package:churchapp/data/model/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  Future<bool> verifyCurrentPassword(String currentPassword);

  Future<void> changeEmailWithConfirmation(
      String currentEmail, String newEmail);

  Future<void> changePhoneWithConfirmation(
      String currentPhone, String newPhone);

  Future<void> changePasswordWithConfirmation(
      String currentPassword, String newPassword);

  Future<void> signOut({VoidCallback? onSignedOut});

  Future<bool> isLoggedIn();

  Future<String?> getCurrentUserEmail();

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

  Future<String?> getUserProfileImageUrl(String userId);
}

class AuthenticationService implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<void> signUpWithPersonalInfo({
    required String firstName,
    required String lastName,
  }) async {
    // Implementação necessária
  }

  @override
  Future<void> signUpWithDateOfBirthAndGender({
    required int? selectedDay,
    required int? selectedMonth,
    required int? selectedYear,
    required String selectedGender,
  }) async {
    // Implementação necessária
  }

  @override
  Future<bool> signUpWithEmailAndConfirmation({
    required String email,
    required String emailConfirmation,
  }) async {
    if (email != emailConfirmation) {
      return false;
    }
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password:
            'dummyPasswordForVerification', // Use uma senha segura ou gerada dinamicamente
      );
      return true;
    } catch (error) {
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
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('FirebaseAuthException during sign up: ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign up: $e');
      }
      rethrow;
    }
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
  Future<void> signOut({VoidCallback? onSignedOut}) async {
    await _firebaseAuth.signOut();
    onSignedOut?.call();
  }

  @override
  Future<String?> getCurrentUserEmail() async {
    try {
      User? user = _firebaseAuth.currentUser;
      return user?.email;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current user email: $e');
      }
      rethrow;
    }
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
    } catch (error) {
      if (kDebugMode) {
        print("User can't be deleted: ${error.toString()}");
      }
    }
  }

  @override
  Future<void> sendPasswordResetMail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }

  @override
  Future<void> changePhoneWithConfirmation(
      String currentPhone, String newPhone) async {
    User? user = _firebaseAuth.currentUser;
    try {
      // Aqui você precisa implementar o código de verificação de telefone usando o Firebase Authentication
      // Obtendo o ID de verificação e o código SMS do Firebase Authentication
      await user?.updatePhoneNumber(PhoneAuthProvider.credential(
        verificationId: '<verificationId>',
        smsCode: '<smsCode>',
      ));
      await _firestore.collection('users').doc(user?.uid).update({
        'phone': newPhone,
      });
    } catch (error) {
      if (kDebugMode) {
        print("Phone number can't be changed: ${error.toString()}");
      }
      rethrow;
    }
  }

  @override
  Future<void> changeEmailWithConfirmation(
      String currentEmail, String newEmail) async {
    User? user = _firebaseAuth.currentUser;
    try {
      await user?.verifyBeforeUpdateEmail(newEmail);
      await _firestore.collection('users').doc(user?.uid).update({
        'email': newEmail,
      });
      await user?.sendEmailVerification();
    } catch (error) {
      if (kDebugMode) {
        print("Email can't be changed: ${error.toString()}");
      }
      rethrow;
    }
  }

  @override
  Future<void> changePasswordWithConfirmation(
      String currentPassword, String newPassword) async {
    User? user = _firebaseAuth.currentUser;
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user?.email ?? '',
        password: currentPassword,
      );
      await user?.reauthenticateWithCredential(credential);
      await user?.updatePassword(newPassword);
    } catch (error) {
      if (kDebugMode) {
        print("Password can't be changed: ${error.toString()}");
      }
      rethrow;
    }
  }

  Future<UserData?> getCurrentUserData() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(user.uid).get();
        if (snapshot.exists) {
          return UserData.fromDocument(snapshot);
        }
        return null;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user data: $e');
      }
      return null;
    }
  }

  @override
  Future<String?> getCurrentUserName() async {
    UserData? userData = await getCurrentUserData();
    return userData?.fullName;
  }

  @override
  Future<bool> verifyCurrentPassword(String currentPassword) async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return false;
    }
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email ?? '',
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to verify current password: $e');
      }
      return false;
    }
  }

  Future<String?> getCurrentUserPhone() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(user.uid).get();
        return snapshot.get('phone');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current user phone: $e');
      }
      return null;
    }
  }

  Future<String?> getUserRole() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          return data['role'] as String?;
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user role: $e');
      }
      return null;
    }
  }

  Future<void> setUserRole(String role) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .update({'role': role});
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error setting user role: $e');
      }
    }
  }

  Future<String> getUserNameById(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot.get('fullName') ?? 'Usuário Desconhecido';
      } else {
        return 'Usuário Desconhecido';
      }
    } catch (e) {
      return 'Erro ao buscar usuário';
    }
  }

  Future<String> getTitleById(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot.get('title') ?? 'Usuário Desconhecido';
      } else {
        return 'Usuário Desconhecido';
      }
    } catch (e) {
      return 'Erro ao buscar usuário';
    }
  }

  Future<bool> isAdmin(String? currentUserId) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          String? role = data['role'];
          return role == 'admin';
        }
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking if user is admin: $e');
      }
      return false;
    }
  }

  @override
  Future<String?> getUserProfileImageUrl(String userId) async {
    try {
      final ref = _storage
          .ref()
          .child('userProfilePictures/$userId/profilePicture.jpg');
      final downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user profile image URL: $e');
      }
      return null;
    }
  }

  Future<String?> getUserImageById(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data();
        return data?['imagePath'] as String?;
      } else {
        if (kDebugMode) {
          print('User document does not exist');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user image URL: $e');
      }
    }
    return null;
  }
}
