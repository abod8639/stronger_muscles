import 'package:flutter/material.dart';

/// Unified border radius constants and helpers for Stronger Muscles app.
///
/// Ensures visual consistency across cards, buttons, dialogs, and inputs.
class AppRadius {
  AppRadius._();

  // ── Raw Values (double) ───────────────────────────────────────────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double bottomSheet = 28.0;
  static const double pill = 999.0;

  // ── Radius Instances ───────────────────────────────────────────────────────
  static const Radius rXs = Radius.circular(xs);
  static const Radius rSm = Radius.circular(sm);
  static const Radius rMd = Radius.circular(md);
  static const Radius rLg = Radius.circular(lg);
  static const Radius rXl = Radius.circular(xl);
  static const Radius rXxl = Radius.circular(xxl);
  static const Radius rBottomSheet = Radius.circular(bottomSheet);
  static const Radius rPill = Radius.circular(pill);

  // ── All-Sides BorderRadius ────────────────────────────────────────────────
  static const BorderRadius allXs = BorderRadius.all(rXs);
  static const BorderRadius allSm = BorderRadius.all(rSm);
  static const BorderRadius allMd = BorderRadius.all(rMd);
  static const BorderRadius allLg = BorderRadius.all(rLg);
  static const BorderRadius allXl = BorderRadius.all(rXl);
  static const BorderRadius allXxl = BorderRadius.all(rXxl);
  static const BorderRadius allPill = BorderRadius.all(rPill);

  // ── Directional BorderRadius ──────────────────────────────────────────────

  /// Top corners only (commonly used for bottom sheets, modal cards)
  static BorderRadius top([double radius = lg]) =>
      BorderRadius.vertical(top: Radius.circular(radius));

  /// Bottom corners only
  static BorderRadius bottom([double radius = lg]) =>
      BorderRadius.vertical(bottom: Radius.circular(radius));

  /// Standard bottom sheet top radius
  static const BorderRadius topBottomSheet =
      BorderRadius.vertical(top: rBottomSheet);

  /// Custom directional corners
  static BorderRadius only({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) =>
      BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      );

  // ── Shape Borders (for Buttons, Cards, Dialogs) ───────────────────────────

  static RoundedRectangleBorder shapeSm =
      const RoundedRectangleBorder(borderRadius: allSm);

  static RoundedRectangleBorder shapeMd =
      const RoundedRectangleBorder(borderRadius: allMd);

  static RoundedRectangleBorder shapeLg =
      const RoundedRectangleBorder(borderRadius: allLg);

  static RoundedRectangleBorder shapeXl =
      const RoundedRectangleBorder(borderRadius: allXl);

  static RoundedRectangleBorder shapePill =
      const RoundedRectangleBorder(borderRadius: allPill);

  static RoundedRectangleBorder rounded(double radius) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
}
