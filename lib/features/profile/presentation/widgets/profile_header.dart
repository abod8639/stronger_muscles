import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/auth/auth_feature.dart';

/// Signed-in user card (avatar, name, email). Tapping opens [onTap].
class ProfileHeader extends ConsumerWidget {
  final VoidCallback? onTap;

  const ProfileHeader({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull;
    if (user == null) return const SizedBox.shrink();

    final textTheme = context.textTheme;

    return AppCard(
      margin: const EdgeInsets.all(AppDimens.spacingLg),
      padding: const EdgeInsets.all(AppDimens.spacingLg + 4),
      onTap: onTap,
      gradient: LinearGradient(
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
        colors: [
          AppColors.primary.withValues(alpha: context.isDark ? 0.18 : 0.1),
          context.colorScheme.surface,
        ],
      ),
      boxShadow: context.subtleShadow,
      child: Row(
        children: [
          AppAvatar(imageUrl: user.photoUrl, size: 68.0, showBorder: true),
          const SizedBox(width: AppDimens.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppDimens.spacingXs),
                Text(
                  user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          if (onTap != null)
            AppIconTile(icon: Icons.edit_outlined, iconSize: 18.0, padding: 8.0, circular: true),
        ],
      ),
    );
  }
}
