class AppTextStrings {
  AppTextStrings._();

  /// App Name
  static const String appName = 'Chat App';

  /// Views App Bar Titles...
  static const String loginViewAppBarTitle = 'Login';
  static const String registerViewAppBarTitle = 'Register';
  static const String homeViewAppBarTitle = 'ChatApp';
  static const String contactsViewAppBarTitle = 'Contacts';

  /// View Headings...
  static const String loginViewHeading = 'Welcome Back!';
  static const String registerViewHeading = 'Let\'s create an account.';

  /// Text Field Labels
  static const String userNameFieldLabel = 'Username';
  static const String emailFieldLabel = 'Email';
  static const String passwordFieldLabel = 'Password';

  /// Text Field Hint...
  static const String messageFieldHint = 'Type your message...';

  /// Buttons Title
  static const String loginButtonText = 'Login';
  static const String registerButtonText = 'Register';
  static const String createAnAccountButtonText = 'Create an account';
  static const String alreadyHaveAnAccountButtonText =
      'Already have an account';
  static const String newChatButtonText = 'New chat';

  /// Error Messages
  static const String onRequiredEmailFormatError =
      'Please enter a valid email address';
  static const String onNoUserFound = 'No user found...';
  static const String onNoChatFound = 'No chat found...';
  static const String onEmptyChat =
      'Start a conversation by typing in the chat box.';

  static String onRequiredFieldError({required String fieldName}) {
    return '$fieldName is required';
  }

  static String onMinPasswordLengthError({required int min}) {
    return 'Must be at least $min characters long.';
  }
}
