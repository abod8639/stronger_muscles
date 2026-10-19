import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_primary_button.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// A reusable empty state widget with icon, title, subtitle, and optional CTA button.
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onActionTap;
  final Color? iconColor;
  final EdgeInsetsGeometry padding;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onActionTap,
    this.iconColor,
    this.padding = const EdgeInsets.all(32.0),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final color = iconColor ?? AppColors.primary;

    return Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90.0,
              height: 90.0,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 46.0,
                color: color,
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
                letterSpacing: -0.3,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8.0),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.0,
                  height: 1.4,
                  color: isDark ? AppColors.grey : AppColors.greyDark,
                ),
              ),
            ],
            if (actionText != null && onActionTap != null) ...[
              const SizedBox(height: 28.0),
              AppPrimaryButton(
                text: actionText!,
                onPressed: onActionTap,
                borderRadius: AppRadius.allLg,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
