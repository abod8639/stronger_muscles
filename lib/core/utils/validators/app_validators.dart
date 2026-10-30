/// Pure form validators shared by auth, profile and any other form.
class AppValidators {
  const AppValidators._();

  static final RegExp _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  /// Validates email address format.
  static String? validateEmail(
    String? value, {
    required String emptyMessage,
    required String invalidMessage,
  }) {
    if (value == null || value.trim().isEmpty) {
      return emptyMessage;
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return invalidMessage;
    }
    return null;
  }

  /// Validates password presence and minimum length.
  static String? validatePassword(
    String? value, {
    required String emptyMessage,
    required String tooShortMessage,
    int minLength = 6,
  }) {
    if (value == null || value.isEmpty) {
      return emptyMessage;
    }
    if (value.length < minLength) {
      return tooShortMessage;
    }
    return null;
  }

  /// Validates full name presence and minimum length.
  static String? validateName(
    String? value, {
    required String emptyMessage,
    int minLength = 2,
  }) {
    if (value == null || value.trim().isEmpty || value.trim().length < minLength) {
      return emptyMessage;
    }
    return null;
  }

  /// Validates password confirmation match.
  static String? validateConfirmPassword(
    String? value,
    String originalPassword, {
    required String emptyMessage,
    required String mismatchMessage,
  }) {
    if (value == null || value.isEmpty) {
      return emptyMessage;
    }
    if (value != originalPassword) {
      return mismatchMessage;
    }
    return null;
  }
}
