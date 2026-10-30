import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Unified floating snack bars (success / error / info) with consistent
/// icon, radius and colors. Replaces ad-hoc `SnackBar(...)` construction.
class AppSnackBar {
  AppSnackBar._();

  static void showSuccess(BuildContext context, String message) => _show(
        context,
        message: message,
        icon: Icons.check_circle_rounded,
        color: AppColors.success,
      );

  static void showError(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      _show(
        context,
        message: message,
        icon: Icons.error_outline_rounded,
        color: AppColors.error,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  static void showInfo(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) =>
      _show(
        context,
        message: message,
        icon: Icons.info_outline_rounded,
        color: AppColors.greyDark,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  static void _show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color color,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          margin: const EdgeInsets.all(16.0),
          shape: AppRadius.shapeMd,
          content: Row(
            children: [
              Icon(icon, color: AppColors.white, size: 20.0),
              const SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  message,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          action: actionLabel != null && onAction != null
              ? SnackBarAction(
                  label: actionLabel,
                  textColor: AppColors.white,
                  onPressed: onAction,
                )
              : null,
        ),
      );
  }
}
