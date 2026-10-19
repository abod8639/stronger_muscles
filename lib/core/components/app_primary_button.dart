import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';
import 'package:stronger_muscles/core/theme/app_shadows.dart';

/// A reusable elevated primary button with loading indicator,
/// icon support, and unified shadows.
class AppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const AppPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = 48.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? AppColors.primary;
    final effectiveFg = foregroundColor ?? AppColors.white;
    final radius = borderRadius ?? AppRadius.allLg;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: onPressed != null && !isLoading
            ? AppShadows.colored(effectiveBg, alpha: 0.28)
            : null,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBg,
          foregroundColor: effectiveFg,
          disabledBackgroundColor: effectiveBg.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(borderRadius: radius),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: effectiveFg),
                    const SizedBox(width: 8.0),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: effectiveFg,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
