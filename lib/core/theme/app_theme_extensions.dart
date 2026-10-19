import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/theme/app_shadows.dart';

/// Extension on [BuildContext] to access unified theme tokens, shadows,
/// and responsive state cleanly across widgets.
extension AppThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Fast context-aware shadow access
  List<BoxShadow> get cardShadow => AppShadows.ofCard(this);
  List<BoxShadow> get subtleShadow => AppShadows.ofSubtle(this);
  List<BoxShadow> get floatingShadow => AppShadows.ofFloating(this);

  /// Locale check helper
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
}
