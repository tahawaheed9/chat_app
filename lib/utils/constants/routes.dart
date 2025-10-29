import 'package:flutter/material.dart';

import 'package:chat_app/views/login/login_view.dart';
import 'package:chat_app/views/register/register_view.dart';
import 'package:chat_app/views/reset_password/reset_password_view.dart';

class Routes {
  Routes._();

  static const loginRoute = '/login';
  static const registerRoute = '/register';
  static const resetPasswordRoute = '/reset-password';

  static Map<String, Widget Function(BuildContext context)> routes = {
    loginRoute: (context) => const LoginView(),
    registerRoute: (context) => const RegisterView(),
    resetPasswordRoute: (context) => const ResetPasswordView(),
  };
}