import 'package:flutter/material.dart';

import 'package:chat_app/utils/constants/routes.dart';

class NavigationController {
  NavigationController._();

  static void pushLoginView(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.loginRoute,
      ModalRoute.withName(Routes.loginRoute),
    );
  }

  static void pushRegisterView(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.registerRoute,
      ModalRoute.withName(Routes.registerRoute),
    );
  }

  static void pushResetPasswordView(BuildContext context) {
    Navigator.of(context).pushNamed(Routes.resetPasswordRoute);
  }
}
