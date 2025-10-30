class AppTextStrings {
  /// App Name
  static const String appName = 'Chat App';

  /// Text Field Labels
  static const String userNameFieldLabel = 'Username';
  static const String emailFieldLabel = 'Email';
  static const String passwordFieldLabel = 'Password';

  /// Buttons Title
  static const String loginButtonText = 'Login';
  static const String registerButtonText = 'Register';
  static const String resetPasswordButtonText = 'Reset Password';
  static const String createAnAccountButtonText = 'Create an account';
  static const String alreadyHaveAnAccountButtonText = 'Already have an account';

  /// Error Messages
  static const String requiredEmailFormatError =
      'Please enter a valid email address';
  static const String onNoUserFound = 'No user found...';

  static String requiredFieldError({required String fieldName}) {
    return '$fieldName is required';
  }

  static String minPasswordLengthError({required int min}) {
    return 'Must be at least $min characters long.';
  }
}
