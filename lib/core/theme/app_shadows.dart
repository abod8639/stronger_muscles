import 'package:flutter/material.dart';

/// Unified shadow system for Stronger Muscles app.
///
/// Provides consistent elevation, blur, spread, and dark/light mode adaptability.
class AppShadows {
  AppShadows._();

  // ── Base Color Palette for Shadows ─────────────────────────────────────────
  static const Color defaultLightShadow = Color(0x14000000); // ~8% black
  static const Color subtleLightShadow = Color(0x08000000);  // ~3% black
  static const Color darkElevationShadow = Color(0x33000000); // ~20% black for dark theme

  // ── Standard Shadows ────────────────────────────────────────────────────────

  /// Standard card shadow with balanced blur and subtle spread.
  /// Ideal for product cards, info containers, and list items.
  static List<BoxShadow> card([Color? shadowColor]) => [
        BoxShadow(
          color: (shadowColor ?? Colors.black).withValues(alpha: 0.08),
          blurRadius: 15.0,
          offset: const Offset(0, 4),
          spreadRadius: 1.5,
        ),
      ];

  /// Subtle shadow for search bars, chips, and small controls.
  static List<BoxShadow> subtle([Color? shadowColor]) => [
        BoxShadow(
          color: (shadowColor ?? Colors.black).withValues(alpha: 0.04),
          blurRadius: 10.0,
          offset: const Offset(0, 2),
        ),
      ];

  /// Soft shadow for delicate containers, tabs, and accordion panels.
  static List<BoxShadow> soft([Color? shadowColor]) => [
        BoxShadow(
          color: (shadowColor ?? Colors.black).withValues(alpha: 0.05),
          blurRadius: 12.0,
          offset: const Offset(0, 3),
        ),
      ];

  /// Floating shadow for modals, dialogs, and elevated action buttons.
  static List<BoxShadow> floating([Color? shadowColor]) => [
        BoxShadow(
          color: (shadowColor ?? Colors.black).withValues(alpha: 0.12),
          blurRadius: 24.0,
          offset: const Offset(0, 8),
          spreadRadius: 2.0,
        ),
      ];

  /// Outer banner shadow for top hero sections and announcement cards.
  static List<BoxShadow> banner([Color? shadowColor]) => [
        BoxShadow(
          color: (shadowColor ?? Colors.black).withValues(alpha: 0.09),
          blurRadius: 12.0,
          offset: const Offset(0, 4),
          blurStyle: BlurStyle.outer,
        ),
      ];

  /// Colored accent glow (e.g., brand red glow on primary buttons or active cards).
  static List<BoxShadow> colored(Color color, {double alpha = 0.25, double blur = 14.0}) => [
        BoxShadow(
          color: color.withValues(alpha: alpha),
          blurRadius: blur,
          offset: const Offset(0, 4),
        ),
      ];

  /// Focused ring or glow effect for active form fields or selected chips.
  static List<BoxShadow> glow(Color color, {double blur = 16.0, double spread = 1.0}) => [
        BoxShadow(
          color: color.withValues(alpha: 0.35),
          blurRadius: blur,
          spreadRadius: spread,
          offset: Offset.zero,
        ),
      ];

  // ── Context-Aware Shadows ───────────────────────────────────────────────────

  /// Theme-adaptive card shadow adjusting based on dark / light mode.
  static List<BoxShadow> ofCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 12.0,
              offset: const Offset(0, 4),
            ),
          ]
        : card();
  }

  /// Theme-adaptive subtle shadow adjusting based on dark / light mode.
  static List<BoxShadow> ofSubtle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.20),
              blurRadius: 8.0,
              offset: const Offset(0, 2),
            ),
          ]
        : subtle();
  }

  /// Theme-adaptive floating shadow for dialogs and sheets.
  static List<BoxShadow> ofFloating(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.50),
              blurRadius: 20.0,
              offset: const Offset(0, 8),
            ),
          ]
        : floating();
  }
}
