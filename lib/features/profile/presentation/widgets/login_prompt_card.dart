import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/components/app_card.dart';
import 'package:stronger_muscles/core/utils/functions/app_guard.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/profile_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/account_settings_list.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

class LoginPromptCard extends ConsumerWidget {
  const LoginPromptCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      margin: const EdgeInsets.all(AppDimens.spacingLg),
      padding: const EdgeInsets.all(AppDimens.spacingXl),
      borderRadius: AppDimens.borderRadiusXl,
      boxShadow: AppDimens.floatingShadow(theme.shadowColor),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingLg),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 60.0,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppDimens.spacingXl),
          Text(
            l10n.signInToYourAccount,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.spacingMd),
          Text(
            l10n.loginMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.spacingLg),
          ElevatedButton.icon(
            onPressed: () => _handleLogin(context, ref),
            icon: const Icon(Icons.login),
            label: Text(l10n.loginButtonLabel),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: const RoundedRectangleBorder(
                borderRadius: AppDimens.borderRadiusMd,
              ),
              elevation: AppDimens.elevationSm,
            ),
          ),
          const SizedBox(height: AppDimens.spacingLg),
          ElevatedButton.icon(
            onPressed: () async {
              AppGuard.runSafeInternet(ref, () async {
                await ref
                    .read(profileControllerProvider.notifier)
                    .signInWithGoogle();
              });
            },
            icon: const Icon(
              Icons.g_mobiledata_outlined,
              size: 35.0,
            ),
            label: Text(l10n.signInWithGoogle),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 10.0,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: AppDimens.borderRadiusMd,
              ),
              elevation: AppDimens.elevationSm,
            ),
          ),
          const SizedBox(height: AppDimens.spacingLg),
          const AccountSettingsList(),
          const SizedBox(height: AppDimens.spacingLg),
        ],
      ),
    );
  }

  Future<void> _handleLogin(BuildContext context, WidgetRef ref) async {
    return AppGuard.runSafeInternet(ref, () async {
      ref.read(routerProvider).push(AppRoutes.auth);
    });
  }
}
