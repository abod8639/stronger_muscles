import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_network_image.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Circular user avatar: network photo when available, otherwise the first
/// letter of [name], otherwise [fallbackIcon]. Optional brand-colored ring.
class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final IconData fallbackIcon;
  final bool showBorder;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40.0,
    this.fallbackIcon = Icons.person,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final initial = (name?.trim().isNotEmpty ?? false) ? name!.trim()[0].toUpperCase() : null;

    final Widget content;
    if (url != null && url.isNotEmpty) {
      content = AppNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        borderRadius: AppRadius.allPill,
        errorIcon: fallbackIcon,
      );
    } else {
      content = Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary.withValues(alpha: 0.12),
        ),
        child: initial != null
            ? Text(
                initial,
                style: context.textTheme.titleMedium?.copyWith(
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              )
            : Icon(fallbackIcon, size: size * 0.5, color: AppColors.primary),
      );
    }

    if (!showBorder) return content;

    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
      child: Container(
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(shape: BoxShape.circle, color: context.colorScheme.surface),
        child: content,
      ),
    );
  }
}
