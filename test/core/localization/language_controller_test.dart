import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/localization/language_controller.dart';

void main() {
  late Directory tempDir;
  late ProviderContainer container;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('lang_ctrl_test_hive_');
    Hive.init(tempDir.path);
  });

  setUp(() async {
    if (!Hive.isBoxOpen('settings')) {
      await Hive.openBox('settings');
    }
    await Hive.box('settings').clear();
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('LanguageController Tests', () {
    test('defaults to English when settings box has no stored language', () {
      final locale = container.read(languageControllerProvider);
      expect(locale.languageCode, 'en');

      final notifier = container.read(languageControllerProvider.notifier);
      expect(notifier.isEnglish, isTrue);
      expect(notifier.isArabic, isFalse);
      expect(notifier.currentLanguageName, 'English');
    });

    test('changes language to Arabic and persists in settings box', () async {
      final notifier = container.read(languageControllerProvider.notifier);
      await notifier.changeLanguage(const Locale('ar'));

      final updatedLocale = container.read(languageControllerProvider);
      expect(updatedLocale.languageCode, 'ar');
      expect(notifier.isArabic, isTrue);
      expect(notifier.isEnglish, isFalse);
      expect(notifier.currentLanguageName, 'العربية');

      expect(Hive.box('settings').get('app_language'), 'ar');
    });

    test('loads saved language from settings box on build', () async {
      await Hive.box('settings').put('app_language', 'ar');

      final freshContainer = ProviderContainer();
      final locale = freshContainer.read(languageControllerProvider);
      expect(locale.languageCode, 'ar');

      final notifier = freshContainer.read(languageControllerProvider.notifier);
      expect(notifier.isArabic, isTrue);
      freshContainer.dispose();
    });
  });
}

