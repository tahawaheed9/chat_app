import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:chat_app/utils/constants/app_sizes.dart';
import 'package:chat_app/views/components/custom_heading.dart';
import 'package:chat_app/views/components/custom_divider.dart';
import 'package:chat_app/utils/constants/app_text_strings.dart';
import 'package:chat_app/views/components/custom_outline_button.dart';
import 'package:chat_app/views/register/components/register_form.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppTextStrings.registerViewAppBarTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.defaultPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CustomHeading(text: AppTextStrings.registerViewHeading),
              const SizedBox(height: AppSizes.spaceBetweenItems),
              const RegisterForm(),
              const CustomDivider(),
              CustomOutlinedButton(
                isSecondary: true,
                text: AppTextStrings.alreadyHaveAnAccountButtonText,
                onPressed: () => Get.offAllNamed('/login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
