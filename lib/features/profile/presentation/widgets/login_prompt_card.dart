import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/functions/app_guard.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/profile_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/account_settings_list.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Signed-out profile: sign-in prompt plus the app settings.
class LoginPromptCard extends ConsumerWidget {
  const LoginPromptCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          margin: const EdgeInsets.all(AppDimens.spacingLg),
          padding: const EdgeInsets.all(AppDimens.spacingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppHeroHeader(
                icon: Icons.shopping_bag_outlined,
                title: l10n.signInToYourAccount,
                subtitle: l10n.loginMessage,
              ),
              const SizedBox(height: AppDimens.spacingXl),
              AppPrimaryButton(
                text: l10n.loginButtonLabel,
                icon: Icons.login_rounded,
                height: 52.0,
                onPressed: () => AppGuard.runSafeInternet(
                  ref,
                  () async => ref.read(routerProvider).push(AppRoutes.auth),
                ),
              ),
              AppOrDivider(label: l10n.or),
              AppSocialButton.google(
                label: l10n.signInWithGoogle,
                onPressed: () => AppGuard.runSafeInternet(
                  ref,
                  () => ref.read(profileControllerProvider.notifier).signInWithGoogle(),
                ),
              ),
            ],
          ),
        ),
        const AccountSettingsList(showEditProfile: false),
      ],
    );
  }
}
