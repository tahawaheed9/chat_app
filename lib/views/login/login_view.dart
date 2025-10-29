import 'package:flutter/material.dart';

import 'package:chat_app/utils/constants/app_sizes.dart';
import 'package:chat_app/views/components/custom_heading.dart';
import 'package:chat_app/views/components/custom_divider.dart';
import 'package:chat_app/utils/constants/app_text_strings.dart';
import 'package:chat_app/views/login/components/login_form.dart';
import 'package:chat_app/views/components/custom_outline_button.dart';
import 'package:chat_app/controllers/navigation/navigation_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.defaultPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CustomHeading(text: 'Welcome Back!'),
              const SizedBox(height: AppSizes.spaceBetweenItems),
              const LoginForm(),
              const CustomDivider(),
              CustomOutlinedButton(
                text: AppTextStrings.resetPasswordButtonText,
                onPressed: () {
                  return NavigationController.pushResetPasswordView(context);
                },
              ),
              const SizedBox(height: AppSizes.spaceBetweenItems),
              CustomOutlinedButton(
                isSecondary: true,
                text: AppTextStrings.createAnAccountButtonText,
                onPressed: () {
                  return NavigationController.pushRegisterView(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
