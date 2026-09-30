import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/components/app_card.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authControllerProvider).value;
    final isDark = theme.brightness == Brightness.dark;

    if (user == null) return const SizedBox.shrink();

    return AppCard(
      margin: const EdgeInsets.all(AppDimens.spacingLg),
      padding: const EdgeInsets.all(AppDimens.spacingXl),
      borderRadius: AppDimens.borderRadiusLg,
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [
          AppColors.primary.withAlpha(30),
          theme.scaffoldBackgroundColor,
        ],
      ),
      boxShadow: AppDimens.subtleShadow(theme.shadowColor),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 2.0,
              ),
            ),
            child: CircleAvatar(
              radius: 35.0,
              backgroundColor: AppColors.greyLight,
              backgroundImage:
                  user.photoUrl != null && user.photoUrl!.isNotEmpty
                  ? NetworkImage(user.photoUrl!)
                  : null,
              child: user.photoUrl == null || user.photoUrl!.isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 35.0,
                      color: AppColors.greyDark,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: AppDimens.spacingLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                  semanticsLabel: user.name,
                ),
                const SizedBox(height: AppDimens.spacingXs),
                Text(
                  user.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: .8,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  semanticsLabel: user.email,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
