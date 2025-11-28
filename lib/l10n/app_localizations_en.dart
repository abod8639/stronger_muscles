// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Stronger Muscles';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get email => 'Email';

  @override
  String get enterEmail => 'Please enter your email';

  @override
  String get validEmail => 'Please enter a valid email';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Please enter your password';

  @override
  String get passwordLength => 'Password must be at least 6 characters';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get forgotPasswordNotImplemented =>
      'Forgot password not implemented yet';

  @override
  String get login => 'Login';

  @override
  String get or => 'OR';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';
}
