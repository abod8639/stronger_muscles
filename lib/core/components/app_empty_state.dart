import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_link_button.dart';
import 'package:stronger_muscles/core/components/app_primary_button.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// A reusable empty / error state widget with icon, title, subtitle,
/// an optional primary CTA and an optional secondary link action.
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final IconData? actionIcon;
  final VoidCallback? onActionTap;
  final String? secondaryActionText;
  final VoidCallback? onSecondaryActionTap;
  final Color? iconColor;
  final EdgeInsetsGeometry padding;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.actionIcon,
    this.onActionTap,
    this.secondaryActionText,
    this.onSecondaryActionTap,
    this.iconColor,
    this.padding = const EdgeInsets.all(32.0),
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.primary;
    final textTheme = context.textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96.0,
              height: 96.0,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: 0.15), width: 6.0),
              ),
              child: Icon(icon, size: 44.0, color: color),
            ),
            const SizedBox(height: 24.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface,
                letterSpacing: -0.3,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8.0),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (actionText != null && onActionTap != null) ...[
              const SizedBox(height: 28.0),
              AppPrimaryButton(
                text: actionText!,
                icon: actionIcon,
                onPressed: onActionTap,
                borderRadius: AppRadius.allLg,
              ),
            ],
            if (secondaryActionText != null && onSecondaryActionTap != null) ...[
              const SizedBox(height: 12.0),
              AppLinkButton(
                text: secondaryActionText!,
                onPressed: onSecondaryActionTap,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
