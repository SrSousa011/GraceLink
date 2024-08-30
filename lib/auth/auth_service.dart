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

  Future<void> deleteUser();

  Future<void> desactivateUser();

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

  Future<void> sendVerificationCode(String phoneNumber);

  Future<void> verifyCode(String verificationId, String smsCode);

  Future<void> sendEmailConfirmation(String email);
}

class AuthenticationService implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
        password: 'dummyPasswordForVerification',
      );
      return true;
    } catch (error) {
      if (kDebugMode) {
        print('Erro ao criar conta: $error');
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
        print('Erro FirebaseAuthException ao criar conta: ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao criar conta: $e');
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
        print('Erro FirebaseAuthException ao fazer login: ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao fazer login: $e');
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
        print('Erro ao obter ID do usuário: $e');
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
        print('Erro ao obter e-mail do usuário: $e');
      }
      rethrow;
    }
  }

  Future<String?> getCurrentUserPhone() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(user.uid).get();
        return snapshot.get('phoneNumber');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current user phone: $e');
      }
      return null;
    }
  }

  @override
  Future<void> changeEmail(String email) async {
    User? user = _firebaseAuth.currentUser;
    try {
      await user?.verifyBeforeUpdateEmail(email);
    } catch (error) {
      if (kDebugMode) {
        print("Não foi possível alterar o e-mail: ${error.toString()}");
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
        print("Não foi possível alterar a senha: ${error.toString()}");
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
        print("Não foi possível excluir o usuário: ${error.toString()}");
      }
    }
  }

  @override
  Future<void> desactivateUser() async {
    User? user = _firebaseAuth.currentUser;
    try {
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'isActive': false,
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao desativar usuário: $e');
      }
      rethrow;
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

  @override
  Future<void> sendPasswordResetMail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Falha ao enviar e-mail de redefinição de senha: $e');
    }
  }

  @override
  Future<void> changePhoneWithConfirmation(
      String currentPhone, String newPhone) async {
    User? user = _firebaseAuth.currentUser;
    try {
      await user?.updatePhoneNumber(PhoneAuthProvider.credential(
        verificationId: '<verificationId>',
        smsCode: '<smsCode>',
      ));
      await _firestore.collection('users').doc(user?.uid).update({
        'phoneNumber': newPhone,
      });
    } catch (error) {
      if (kDebugMode) {
        print(
            "Não foi possível alterar o número de telefone: ${error.toString()}");
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
        print("Não foi possível alterar o e-mail: ${error.toString()}");
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
        print("Não foi possível alterar a senha: ${error.toString()}");
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
        print('Erro ao obter dados do usuário: $e');
      }
      rethrow;
    }
  }

  @override
  Future<void> sendEmailConfirmation(String email) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('Nenhum usuário conectado');
      }

      await user.sendEmailVerification();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao enviar confirmação por e-mail: $e');
      }
      rethrow;
    }
  }

  @override
  Future<String?> getCurrentUserName() async {
    UserData? userData = await getCurrentUserData();
    return userData?.fullName;
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

  Future<void> updateVerificationStatus() async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) return;

    final userId = user.uid;
    final isEmailVerified = user.emailVerified;

    final isPhoneVerified = await _isPhoneVerified(userId);

    try {
      await _firestore.collection('usersVerification').doc(userId).set({
        'isEmailVerified': isEmailVerified,
        'isPhoneVerified': isPhoneVerified,
      }, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao atualizar status de verificação: $e');
      }
    }
  }

  Future<bool> _isPhoneVerified(String userId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('usersVerification').doc(userId).get();

      if (snapshot.exists) {
        return snapshot.get('isPhoneVerified') ?? false;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao verificar status do telefone: $e');
      }
      return false;
    }
  }

  Future<void> updatePhoneVerificationStatus(
      String userId, bool isVerified) async {
    try {
      await _firestore.collection('usersVerification').doc(userId).update({
        'isPhoneVerified': isVerified,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao atualizar o status de verificação do telefone: $e');
      }
    }
  }

  @override
  Future<void> verifyCode(String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await updatePhoneVerificationStatus(userCredential.user!.uid, true);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao verificar código: $e');
      }
      rethrow;
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) return;

    try {
      await user.sendEmailVerification();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao enviar confirmação por e-mail: $e');
      }
      rethrow;
    }
  }

  Future<void> updateEmailVerificationStatus(
      String userId, bool isVerified) async {
    try {
      await _firestore.collection('usersVerification').doc(userId).set({
        'isEmailVerified': isVerified,
      }, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao atualizar o status de verificação do e-mail: $e');
      }
    }
  }

  Future<bool> getEmailVerificationStatus() async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) return false;

    try {
      await user.reload();
      return user.emailVerified;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao verificar e atualizar o status do e-mail: $e');
      }
      return false;
    }
  }

  Future<bool> getPhoneVerificationStatus() async {
    User? user = _firebaseAuth.currentUser;
    if (user == null) return false;

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('usersVerification').doc(user.uid).get();

      if (userDoc.exists && userDoc.data() is Map<String, dynamic>) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        return data['isPhoneVerified'] ?? false;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao verificar o status do telefone: $e');
      }
      return false;
    }
  }

  Future<void> sendVerificationCode(String phoneNumber) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (kDebugMode) {
          print('Erro ao enviar código de verificação: $e');
        }
      },
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<bool> verifyPhoneCode(String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _firebaseAuth.signInWithCredential(credential);

      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        await _firestore.collection('usersVerification').doc(user.uid).update({
          'isPhoneVerified': true,
        });
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao verificar o código do telefone: $e');
      }
      return false;
    }
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
