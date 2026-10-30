import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Round, softly elevated icon button (filter, notifications, cart...),
/// with an optional count badge.
class AppCircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final int badgeCount;
  final double size;

  const AppCircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.badgeCount = 0,
    this.size = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = context.colorScheme.onSurfaceVariant;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        shape: BoxShape.circle,
        boxShadow: context.subtleShadow,
      ),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Badge(
          isLabelVisible: badgeCount > 0,
          backgroundColor: AppColors.primary,
          label: Text(
            badgeCount > 99 ? '99+' : '$badgeCount',
            style: context.textTheme.labelSmall?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Icon(icon, color: iconColor),
        ),
      ),
    );
  }
}
