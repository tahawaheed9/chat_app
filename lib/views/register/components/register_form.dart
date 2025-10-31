import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/utils/constants/app_sizes.dart';
import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/controller/database_controller.dart';
import 'package:chat_app/utils/validators/app_validators.dart';
import 'package:chat_app/utils/constants/app_text_strings.dart';
import 'package:chat_app/views/components/custom_outline_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late final GlobalKey<FormState> _formKey;

  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _password;

  late final AuthController _auth;
  late final DatabaseController _dbController;

  bool _isObscureText = true;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();

    _username = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();

    _auth = Get.find<AuthController>();
    _dbController = Get.find<DatabaseController>();
  }

  @override
  void dispose() {
    _username.dispose();
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
              controller: _username,
              autofocus: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline),
                hint: Text(AppTextStrings.userNameFieldLabel),
                border: OutlineInputBorder(),
              ),
              validator: (String? value) {
                return AppValidators.required(
                  value: value,
                  fieldName: AppTextStrings.userNameFieldLabel,
                );
              },
            ),

            const SizedBox(height: AppSizes.spaceBetweenItems),

            TextFormField(
              controller: _email,
              autocorrect: false,
              textInputAction: TextInputAction.next,
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
              text: AppTextStrings.registerButtonText,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final String username = _username.text.trim();
                  final String email = _email.text.trim();
                  final String password = _password.text.trim();

                  await _auth.registerUser(email: email, password: password);

                  final String userId = _auth.currentUser!.uid;

                  UserModel userData = UserModel(
                    userId: userId,
                    username: username,
                    email: email,
                  );

                  await _dbController.setUserData(userData: userData);
                  return;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
