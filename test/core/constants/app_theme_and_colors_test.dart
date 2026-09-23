import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_theme.dart';

void main() {
  group('AppColors Tests', () {
    test('primary brand colors are defined properly', () {
      expect(AppColors.primary, const Color(0xFFD32F2F));
      expect(AppColors.primaryDark, const Color(0xFFB71C1C));
      expect(AppColors.accent, const Color(0xFFFF4081));
    });

    test('functional status colors are defined', () {
      expect(AppColors.success, const Color(0xFF4CAF50));
      expect(AppColors.warning, const Color(0xFFFFC107));
      expect(AppColors.error, const Color(0xFFD32F2F));
      expect(AppColors.info, const Color(0xFF2196F3));
    });
  });

  group('AppTheme Tests', () {
    test('lightTheme has correct brightness and primary color scheme', () {
      final theme = AppTheme.lightTheme;
      expect(theme.brightness, Brightness.light);
      expect(theme.primaryColor, AppColors.primary);
      expect(theme.scaffoldBackgroundColor, AppColors.backgroundLight);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.surface, AppColors.surfaceLight);
    });

    test('darkTheme has dark brightness and dark background', () {
      final theme = AppTheme.darkTheme;
      expect(theme.brightness, Brightness.dark);
      expect(theme.primaryColor, AppColors.primaryDark);
      expect(theme.scaffoldBackgroundColor, AppColors.backgroundDark);
      expect(theme.colorScheme.surface, AppColors.surfaceDark);
    });
  });
}
