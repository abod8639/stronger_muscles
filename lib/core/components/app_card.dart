import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';
import 'package:stronger_muscles/core/theme/app_shadows.dart';

/// A unified, reusable card component with consistent border radius,
/// shadow, and theme-adaptive surface colors.
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

    final effectiveColor = color ??
        (gradient == null
            ? theme.colorScheme.surface
            : null);
    final effectiveBorderRadius = borderRadius ?? AppRadius.allLg;
    final effectiveShadow = boxShadow ?? AppShadows.ofCard(context);

    if (onTap != null) {
      return Padding(
        padding: margin ?? EdgeInsets.zero,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: effectiveBorderRadius is BorderRadius
                ? effectiveBorderRadius
                : AppRadius.allLg,
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

    return Container(
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
  }
}
