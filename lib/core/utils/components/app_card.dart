import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';

/// A unified, reusable card component with consistent border radius,
/// shadow, and theme-adaptive colors.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Gradient? gradient;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final Border? border;
  final VoidCallback? onTap;
  final Clip clipBehavior;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.gradient,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.onTap,
    this.clipBehavior = Clip.antiAlias,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveColor = color ??
        (gradient == null
            ? (isDark ? AppColors.surfaceDark : AppColors.surfaceLight)
            : null);
    final effectiveBorderRadius = borderRadius ?? AppDimens.borderRadiusLg;
    final effectiveShadow = boxShadow ?? AppDimens.cardShadow(theme.shadowColor);

    Widget card = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: effectiveColor,
        gradient: gradient,
        borderRadius: effectiveBorderRadius,
        boxShadow: effectiveShadow,
        border: border,
      ),
      clipBehavior: clipBehavior,
      child: child,
    );

    if (onTap != null) {
      return Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: effectiveBorderRadius is BorderRadius
                ? effectiveBorderRadius
                : AppDimens.borderRadiusLg,
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: effectiveColor,
                gradient: gradient,
                borderRadius: effectiveBorderRadius,
                boxShadow: effectiveShadow,
                border: border,
              ),
              clipBehavior: clipBehavior,
              child: child,
            ),
          ),
        ),
      );
    }

    return card;
  }
}
