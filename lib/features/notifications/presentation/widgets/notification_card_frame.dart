import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Shared shell for notification cards: tappable [AppCard] that is tinted and
/// outlined in the brand color while unread.
class NotificationCardFrame extends StatelessWidget {
  static const EdgeInsets margin = EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0);

  final bool isRead;
  final VoidCallback onTap;
  final Widget child;

  const NotificationCardFrame({
    super.key,
    required this.isRead,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final surface = context.colorScheme.surface;

    return AppCard(
      margin: margin,
      padding: const EdgeInsets.all(14.0),
      onTap: onTap,
      color: isRead
          ? surface
          : Color.alphaBlend(AppColors.primary.withValues(alpha: context.isDark ? 0.08 : 0.04), surface),
      border: Border.all(
        color: isRead
            ? context.colorScheme.outlineVariant.withValues(alpha: 0.4)
            : AppColors.primary.withValues(alpha: 0.45),
        width: isRead ? 1.0 : 1.5,
      ),
      child: child,
    );
  }
}

/// Small brand-colored dot marking unread content.
class UnreadDot extends StatelessWidget {
  const UnreadDot({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: 8.0,
      child: DecoratedBox(
        decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
      ),
    );
  }
}
