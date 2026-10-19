import 'dart:ui';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

part 'language_controller.g.dart';

const String _languageStorageKey = 'app_language';
const String _defaultLanguage = 'en';
const String _arabicCode = 'ar';
const String _englishCode = 'en';
const String _arabicLabel = 'العربية';
const String _englishLabel = 'English';

@riverpod
class LanguageController extends _$LanguageController {
  Box? _settingsBox;

  @override
  Locale build() {
    if (Hive.isBoxOpen('settings')) {
      _settingsBox = Hive.box('settings');
      final savedLanguageCode = _settingsBox?.get(_languageStorageKey);
      if (savedLanguageCode != null) {
        return Locale(savedLanguageCode);
      }
    }
    return const Locale(_defaultLanguage);
  }

  Future<void> changeLanguage(Locale locale) async {
    state = locale;
    await _settingsBox?.put(_languageStorageKey, locale.languageCode);
  }

  String get currentLanguageName {
    return state.languageCode == _arabicCode ? _arabicLabel : _englishLabel;
  }

  bool get isArabic => state.languageCode == _arabicCode;
  bool get isEnglish => state.languageCode == _englishCode;
}
