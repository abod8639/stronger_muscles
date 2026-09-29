import 'package:flutter/material.dart';

/// Unified dimension constants for shadows, border radii, and spacing.
/// Use these across all features to ensure visual consistency.
class AppDimens {
  AppDimens._();

  // ── Border Radius ──────────────────────────────────────────────────────
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;

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

  // ── Common BoxShadow ───────────────────────────────────────────────────
  static List<BoxShadow> cardShadow(Color shadowColor) => [
        BoxShadow(
          color: shadowColor.withValues(alpha: 0.08),
          blurRadius: 15.0,
          offset: const Offset(0, 4),
          spreadRadius: 2,
        ),
      ];
}
