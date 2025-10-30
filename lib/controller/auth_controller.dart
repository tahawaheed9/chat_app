import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chat_app/utils/constants/routes.dart';
import 'package:chat_app/controller/exceptions/auth_exceptions.dart';

class AuthController extends GetxController {
  late final FirebaseAuth _auth;

  AuthController() {
    _auth = FirebaseAuth.instance;
  }

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
  Future<User> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _auth.currentUser;
      if (user != null) {
        Get.offAllNamed(Routes.loginRoute);
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
  Future<User> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = _auth.currentUser;
      if (user != null) {
        Get.offAllNamed(Routes.homeRoute);
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
      Get.offAllNamed(Routes.loginRoute);
      return;
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
}
