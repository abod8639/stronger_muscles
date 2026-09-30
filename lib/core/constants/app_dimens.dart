import 'package:flutter/material.dart';

/// Unified dimension constants for shadows, border radii, and spacing.
/// Use these across all features to ensure visual consistency.
class AppDimens {
  AppDimens._();

  // ── Border Radius ──────────────────────────────────────────────────────
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;

  // ── Helper BorderRadius Objects ────────────────────────────────────────
  static const BorderRadius borderRadiusXs = BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius borderRadiusSm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius borderRadiusMd = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius borderRadiusLg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius borderRadiusXl = BorderRadius.all(Radius.circular(radiusXl));

  // ── Elevation / Shadow ─────────────────────────────────────────────────
  static const double elevationSm = 2.0;
  static const double elevationMd = 4.0;
  static const double elevationLg = 8.0;

  // ── Spacing ────────────────────────────────────────────────────────────
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 12.0;
  static const double spacingLg = 16.0;
  static const double spacingXl = 24.0;

  // ── Icon Sizes ─────────────────────────────────────────────────────────
  static const double iconSm = 20.0;
  static const double iconMd = 28.0;
  static const double iconLg = 40.0;
  static const double iconXl = 80.0;

  // ── Image Sizes ────────────────────────────────────────────────────────
  static const double thumbnailSize = 100.0;

  // ── Bottom Sheet ────────────────────────────────────────────────────────
  static const double radiusBottomSheet = 28.0;
  static const BorderRadius borderRadiusBottomSheet =
      BorderRadius.vertical(top: Radius.circular(radiusBottomSheet));

  // ── Common BoxShadow ───────────────────────────────────────────────────
  /// Shadow used on cards with moderate elevation (product cards, etc.)
  static List<BoxShadow> cardShadow([Color? shadowColor]) => [
        BoxShadow(
          color: (shadowColor ?? Colors.black).withValues(alpha: 0.08),
          blurRadius: 15.0,
          offset: const Offset(0, 4),
          spreadRadius: 2,
        ),
      ];

  /// Subtle shadow used on search bars, icon buttons, and inline controls
  static List<BoxShadow> subtleShadow([Color? shadowColor]) => [
        BoxShadow(
          color: (shadowColor ?? Colors.black).withValues(alpha: 0.03),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  /// Outer shadow used on banners, promotional cards, and featured highlights
  static List<BoxShadow> bannerShadow([Color? shadowColor]) => [
        BoxShadow(
          color: (shadowColor ?? Colors.black).withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
          blurStyle: BlurStyle.outer,
        ),
      ];

  /// Floating / elevated shadow for prominent cards, dialogs, and floating sheets
  static List<BoxShadow> floatingShadow([Color? shadowColor]) => [
        BoxShadow(
          color: (shadowColor ?? Colors.black).withValues(alpha: 0.1),
          blurRadius: 20.0,
          offset: const Offset(0, 10),
        ),
      ];

  // ── Pill / Stadium Radius ──────────────────────────────────────────────
  static const double radiusPill = 999.0;
  static const BorderRadius borderRadiusPill = BorderRadius.all(Radius.circular(radiusPill));

  /// Subtle soft shadow for delicate containers, chips, and review cards
  static List<BoxShadow> softShadow([Color? shadowColor]) => [
        BoxShadow(
          color: (shadowColor ?? Colors.black).withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  /// Colored glow or accent shadow for stat cards and key buttons
  static List<BoxShadow> coloredShadow(Color color, {double alpha = 0.3}) => [
        BoxShadow(
          color: color.withValues(alpha: alpha),
          blurRadius: 12.0,
          offset: const Offset(0, 4),
        ),
      ];
}
