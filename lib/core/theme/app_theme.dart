import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_text_styles.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';

/// Central application theme: one builder produces the light and dark themes
/// so both stay in sync. Components read colors from [ColorScheme] (e.g.
/// `outlineVariant` for borders, `surfaceContainerHighest` for muted fills,
/// `onSurfaceVariant` for secondary text) instead of branching on brightness.
class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = _build(Brightness.light);
  static final ThemeData darkTheme = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryDark : AppColors.primary;
    final onSurface = isDark ? AppColors.white : AppColors.black;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    ).copyWith(
      primary: primary,
      onPrimary: AppColors.white,
      secondary: AppColors.accent,
      onSecondary: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      surface: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      onSurface: onSurface,
      onSurfaceVariant: isDark ? const Color(0xFF9E9E9E) : AppColors.greyDark,
      surfaceContainerLowest: isDark ? AppColors.backgroundDark : AppColors.white,
      surfaceContainerHighest: isDark ? const Color(0xFF2A2A2A) : AppColors.greyLight,
      outline: isDark ? const Color(0xFF5C5C5C) : const Color(0xFFBDBDBD),
      outlineVariant: isDark ? const Color(0x1FFFFFFF) : AppColors.greyMedium,
    );

    OutlineInputBorder inputBorder(Color color, [double width = 1.0]) => OutlineInputBorder(
          borderRadius: AppRadius.allMd,
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      primaryColor: primary,
      scaffoldBackgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: onSurface,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h3.copyWith(color: onSurface, fontWeight: FontWeight.bold),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.h1.copyWith(color: onSurface),
        displayMedium: AppTextStyles.h2.copyWith(color: onSurface),
        displaySmall: AppTextStyles.h3.copyWith(color: onSurface),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: onSurface),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: onSurface),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant),
        labelLarge: AppTextStyles.button,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: AppColors.white,
          textStyle: AppTextStyles.button,
          shape: AppRadius.shapeMd,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF242424) : AppColors.greyLight,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 13.0),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
        border: inputBorder(colorScheme.outlineVariant),
        enabledBorder: inputBorder(colorScheme.outlineVariant),
        focusedBorder: inputBorder(AppColors.primary, 1.5),
        errorBorder: inputBorder(AppColors.error),
        focusedErrorBorder: inputBorder(AppColors.error, 1.5),
      ),
      chipTheme: ChipThemeData(
        shape: AppRadius.shapePill,
        side: BorderSide(color: colorScheme.outlineVariant),
        backgroundColor: colorScheme.surface,
        selectedColor: AppColors.primary,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: AppRadius.shapeLg,
        elevation: 0,
      ),
      dividerTheme: DividerThemeData(color: colorScheme.outlineVariant, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: AppRadius.shapeMd,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.topBottomSheet),
        showDragHandle: false,
      ),
      dialogTheme: DialogThemeData(shape: AppRadius.shapeXl, backgroundColor: colorScheme.surface),
    );
  }
}
