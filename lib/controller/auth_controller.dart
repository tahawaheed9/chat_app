import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chat_app/controller/exceptions/auth_exceptions.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  // Get User...
  User? get currentUser {
    final user = _auth.currentUser;
    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  // Register User...
  Future<User> registerUser() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      final user = _auth.currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-credential') {
        debugPrint('Exception: ${error.code}');
        throw InvalidCredentialsAuthException();
      } else if (error.code == 'email-already-in-use') {
        debugPrint('Exception: ${error.code}');
        throw EmailAlreadyInUseAuthException();
      } else {
        debugPrint('Exception: ${error.code}');
        throw GenericAuthException();
      }
    } catch (error) {
      debugPrint('Exception: ${error.toString()}');
      throw GenericAuthException();
    }
  }

  // Login User...
  Future<User> loginUser() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      final user = _auth.currentUser;
      if (user != null) {
        Get.offAllNamed('/home');
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-credential') {
        debugPrint('Exception: ${error.code}');
        throw InvalidCredentialsAuthException();
      } else if (error.code == 'too-many-requests') {
        debugPrint('Exception: ${error.code}');
        throw TooManyRequestsAuthException();
      } else {
        debugPrint('Exception: ${error.code}');
        throw GenericAuthException();
      }
    } catch (error) {
      debugPrint('Exception: ${error.toString()}');
      throw GenericAuthException();
    }
  }

  // Logout User...
  Future<void> logoutUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _auth.signOut();
      Get.offAllNamed('/login');
      return;
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
}
