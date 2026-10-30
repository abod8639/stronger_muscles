import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// A compact, bold text button styled as an inline link
/// (e.g. "Forgot password?", "Sign up", "See all").
class AppLinkButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const AppLinkButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.fontSize = 14.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: effectiveColor,
        padding: padding,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: AppRadius.shapeSm,
      ),
      child: Text(
        text,
        style: context.textTheme.labelLarge?.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: onPressed == null
              ? effectiveColor.withValues(alpha: 0.5)
              : effectiveColor,
        ),
      ),
    );
  }
}
