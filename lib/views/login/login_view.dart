import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:chat_app/utils/constants/routes.dart';
import 'package:chat_app/utils/constants/app_sizes.dart';
import 'package:chat_app/views/components/custom_heading.dart';
import 'package:chat_app/views/components/custom_divider.dart';
import 'package:chat_app/utils/constants/app_text_strings.dart';
import 'package:chat_app/views/login/components/login_form.dart';
import 'package:chat_app/views/components/custom_outline_button.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppTextStrings.loginViewAppBarTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.defaultPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CustomHeading(text: AppTextStrings.loginViewHeading),
              const SizedBox(height: AppSizes.spaceBetweenItems),
              const LoginForm(),
              const CustomDivider(),
              CustomOutlinedButton(
                isSecondary: true,
                text: AppTextStrings.createAnAccountButtonText,
                onPressed: () => Get.offAllNamed(Routes.registerRoute),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
