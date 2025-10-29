import 'package:flutter/material.dart';

import 'package:chat_app/utils/constants/app_sizes.dart';
import 'package:chat_app/utils/validators/app_validators.dart';
import 'package:chat_app/utils/constants/app_text_strings.dart';
import 'package:chat_app/views/components/custom_outline_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _email;
  late final TextEditingController _password;

  bool _isObscureText = true;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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

            TextFormField(
              controller: _password,
              autocorrect: false,
              enableSuggestions: false,
              obscureText: _isObscureText,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline),
                hint: const Text(AppTextStrings.passwordFieldLabel),
                border: const OutlineInputBorder(),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isObscureText = !_isObscureText;
                    });
                  },
                  child: Icon(
                    _isObscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (String? value) {
                return AppValidators.required(
                  value: value,
                  fieldName: AppTextStrings.passwordFieldLabel,
                );
              },
            ),

            const SizedBox(height: AppSizes.spaceBetweenItems),

            CustomOutlinedButton(
              text: AppTextStrings.loginButtonText,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final email = _email.text.trim();
                  final password = _password.text.trim();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
