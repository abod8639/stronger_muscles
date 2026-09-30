import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';

/// A reusable badge widget with configurable colors, borders, and corner radius.
/// Uses [AppDimens] for consistent border radii and spacing.
class AppBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final Color? backgroundColor;
  final Color? textColor;
  final Gradient? gradient;
  final Border? border;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double alpha;

  const AppBadge({
    super.key,
    required this.label,
    this.icon,
    required this.color,
    this.backgroundColor,
    this.textColor,
    this.gradient,
    this.border,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.alpha = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ??
        (gradient == null ? color.withValues(alpha: alpha) : null);
    final effectiveBorderRadius = borderRadius ?? AppDimens.borderRadiusSm;
    final effectiveTextColor = textColor ?? color;

    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppDimens.spacingSm,
            vertical: AppDimens.spacingXs,
          ),
      decoration: BoxDecoration(
        color: effectiveBgColor,
        gradient: gradient,
        borderRadius: effectiveBorderRadius,
        border: border ??
            (gradient == null
                ? Border.all(color: color.withValues(alpha: 0.4), width: 1.0)
                : null),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14.0, color: effectiveTextColor),
            const SizedBox(width: AppDimens.spacingXs),
          ],
          Text(
            label,
            style: textStyle ??
                TextStyle(
                  color: effectiveTextColor,
                  fontSize: 11.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.4,
                ),
          ),
        ],
      ),
    );
  }
}
