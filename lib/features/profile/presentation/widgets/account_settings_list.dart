import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/notifications/notifications_feature.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/language_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/theme_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// App & account settings: profile, theme, notifications, language, help, about.
class AccountSettingsList extends ConsumerWidget {
  /// Hide "Edit profile" when nobody is signed in.
  final bool showEditProfile;

  const AccountSettingsList({super.key, this.showEditProfile = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isDarkMode = ref.watch(themeControllerProvider);
    final themeNotifier = ref.read(themeControllerProvider.notifier);
    ref.watch(languageControllerProvider);
    final languageName = ref.read(languageControllerProvider.notifier).currentLanguageName;
    final unreadNotifications = ref.watch(unreadNotificationCountProvider);

    final tiles = <Widget>[
      if (showEditProfile)
        AppListTile(
          icon: Icons.person_outline_rounded,
          title: l10n.editProfile,
          onTap: () => context.push(AppRoutes.editUserInfo),
        ),
      AppListTile(
        icon: isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
        title: l10n.theme,
        showChevron: false,
        onTap: themeNotifier.toggleTheme,
        trailing: Switch(
          value: isDarkMode,
          onChanged: (_) => themeNotifier.toggleTheme(),
          activeThumbColor: AppColors.primary,
        ),
      ),
      AppListTile(
        icon: Icons.notifications_outlined,
        title: l10n.notifications,
        onTap: () => context.push(AppRoutes.notifications),
        trailing: unreadNotifications > 0
            ? AppBadge(
                label: '$unreadNotifications',
                color: AppColors.primary,
                backgroundColor: AppColors.primary,
                textColor: AppColors.white,
                borderRadius: AppRadius.allPill,
              )
            : null,
      ),
      AppListTile(
        icon: Icons.language_outlined,
        title: l10n.language,
        onTap: () => _showLanguagePicker(context, ref),
        trailing: Text(
          languageName,
          style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurfaceVariant),
        ),
      ),
      AppListTile(
        icon: Icons.help_outline_rounded,
        title: l10n.helpSupport,
        onTap: () => context.push(AppRoutes.helpSupport),
      ),
      AppListTile(
        icon: Icons.info_outline_rounded,
        title: l10n.about,
        onTap: () => showAboutDialog(
          context: context,
          applicationName: l10n.appTitle,
          applicationIcon: const AppIconTile(icon: Icons.fitness_center_rounded),
        ),
      ),
    ];

    return AppCard(
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSectionTitle(
            title: l10n.accountSettings,
            padding: const EdgeInsets.fromLTRB(
              AppDimens.spacingLg,
              AppDimens.spacingLg,
              AppDimens.spacingLg,
              AppDimens.spacingXs,
            ),
          ),
          for (final (index, tile) in tiles.indexed) ...[
            if (index > 0)
              Divider(
                height: 1,
                indent: AppDimens.spacingLg,
                endIndent: AppDimens.spacingLg,
                color: context.colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            tile,
          ],
        ],
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    AppBottomSheetScaffold.show<void>(
      context,
      (sheetContext) {
        final current = ref.read(languageControllerProvider).languageCode;
        void select(String code) {
          ref.read(languageControllerProvider.notifier).changeLanguage(Locale(code));
          Navigator.pop(sheetContext);
        }

        return AppBottomSheetScaffold(
          icon: Icons.language_outlined,
          title: l10n.language,
          child: Column(
            children: [
              for (final (code, name) in [('en', l10n.english), ('ar', l10n.arabic)])
                AppSelectableCard<String>(
                  value: code,
                  groupValue: current,
                  title: name,
                  leadingIcon: Icons.translate_rounded,
                  onChanged: (value) {
                    if (value != null) select(value);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
