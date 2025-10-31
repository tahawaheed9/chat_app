import 'package:chat_app/utils/constants/app_text_strings.dart';

class AppValidators {
  /// Regular expression for basic email format validation
  static final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  /// Required Field Validation
  static String? required({required String? value, required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return AppTextStrings.onRequiredFieldError(fieldName: fieldName);
    }
    return null;
  }

  /// Email Format Validation

  /// Checks if the provided value is a valid email address format.
  static String? isValidEmail({required String? value}) {
    // First, check if the field is empty.
    if (value == null || value.trim().isEmpty) {
      return AppTextStrings.onRequiredFieldError(
        fieldName: AppTextStrings.emailFieldLabel,
      );
    }

    // Check if the format matches the standard email regex.
    if (!_emailRegex.hasMatch(value.trim())) {
      return AppTextStrings.onRequiredEmailFormatError;
    }
    return null;
  }
}
