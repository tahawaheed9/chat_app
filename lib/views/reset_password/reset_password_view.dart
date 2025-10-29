import 'package:flutter/material.dart';

import 'package:chat_app/utils/constants/app_sizes.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.defaultPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Enter your registered email address to reset your password.',
              ),
              const SizedBox(height: AppSizes.spaceBetweenItems),
            ],
          ),
        ),
      ),
    );
  }
}
