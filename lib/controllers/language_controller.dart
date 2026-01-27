import 'dart:ui';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

const String _languageStorageKey = 'app_language';
const String _defaultLanguage = 'en';
const String _arabicCode = 'ar';
const String _englishCode = 'en';
const String _arabicLabel = 'العربية';
const String _englishLabel = 'English';

class LanguageController extends GetxController {
  final Rx<Locale> currentLocale = const Locale(_defaultLanguage).obs;
  late Box _settingsBox;

  @override
  void onInit() {
    super.onInit();
    _settingsBox = Hive.box('settings');
    loadSavedLanguage();
  }

  /// Load saved language from storage or use device locale
  void loadSavedLanguage() {
    final savedLanguageCode = _settingsBox.get(_languageStorageKey);

    if (savedLanguageCode != null) {
      // Use saved language
      currentLocale.value = Locale(savedLanguageCode);
      Get.updateLocale(currentLocale.value);
    } else {
      // First time launch - use device locale
      final deviceLocale = Get.deviceLocale;
      if (deviceLocale != null &&
          _isSupportedLocale(deviceLocale.languageCode)) {
        currentLocale.value = Locale(deviceLocale.languageCode);
        Get.updateLocale(currentLocale.value);
      } else {
        // Fallback to English if device locale is not supported
        currentLocale.value = const Locale(_defaultLanguage);
        Get.updateLocale(currentLocale.value);
      }
    }
  }

  /// Change language and save to storage
  Future<void> changeLanguage(Locale locale) async {
    currentLocale.value = locale;
    await _settingsBox.put(_languageStorageKey, locale.languageCode);
    Get.updateLocale(locale);
  }

  /// Check if locale is supported
  bool _isSupportedLocale(String languageCode) {
    return languageCode == _englishCode || languageCode == _arabicCode;
  }

  /// Get current language name
  String get currentLanguageName {
    return currentLocale.value.languageCode == _arabicCode ? _arabicLabel : _englishLabel;
  }

  /// Check if current language is Arabic
  bool get isArabic => currentLocale.value.languageCode == _arabicCode;

  /// Check if current language is English
  bool get isEnglish => currentLocale.value.languageCode == _englishCode;
}
