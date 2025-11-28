// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'عضلات أقوى';

  @override
  String get welcomeBack => 'مرحبًا بعودتك!';

  @override
  String get signInToContinue => 'تسجيل الدخول للمتابعة';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get enterEmail => 'يرجى إدخال البريد الإلكتروني';

  @override
  String get validEmail => 'يرجى إدخال بريد إلكتروني صالح';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterPassword => 'يرجى إدخال كلمة المرور';

  @override
  String get passwordLength => 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get forgotPasswordNotImplemented =>
      'نسيت كلمة المرور لم يتم تنفيذها بعد';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get or => 'أو';

  @override
  String get signInWithGoogle => 'تسجيل الدخول باستخدام Google';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get signUp => 'إنشاء حساب';
}
