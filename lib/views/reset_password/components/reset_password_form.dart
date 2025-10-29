import 'package:flutter/material.dart';

import 'package:chat_app/utils/constants/app_sizes.dart';
import 'package:chat_app/utils/validators/app_validators.dart';
import 'package:chat_app/utils/constants/app_text_strings.dart';
import 'package:chat_app/views/components/custom_outline_button.dart';

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({super.key});

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _email = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: AppSizes.defaultConstrainedWidth,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _email,
              autofocus: true,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email_outlined),
                hint: Text(AppTextStrings.emailFieldLabel),
                border: OutlineInputBorder(),
              ),
              validator: (String? value) {
                return AppValidators.isValidEmail(value: value);
              },
            ),

            const SizedBox(height: AppSizes.spaceBetweenItems),

            CustomOutlinedButton(
              text: AppTextStrings.loginButtonText,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final email = _email.text.trim();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
