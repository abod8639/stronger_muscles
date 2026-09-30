import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/components/app_card.dart';
import 'package:stronger_muscles/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/theme_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/language_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

class AccountSettingsList extends ConsumerWidget {
  const AccountSettingsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(themeControllerProvider);
    final themeNotifier = ref.watch(themeControllerProvider.notifier);
    final languageNotifier = ref.watch(languageControllerProvider.notifier);
    final currentLocale = ref.watch(languageControllerProvider);
    final isDark = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context)!;
    final unreadNotificationCount = ref.watch(unreadNotificationCountProvider);

    return AppCard(
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
      padding: EdgeInsets.zero,
      borderRadius: AppDimens.borderRadiusLg,
      boxShadow: AppDimens.cardShadow(theme.shadowColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppDimens.spacingXl),
            child: Text(
              localizations.accountSettings,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
          ),
          _buildSettingItem(
            icon: Icons.person_outline,
            title: localizations.editProfile,
            onTap: () => context.push(AppRoutes.editUserInfo),
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildSettingItem(
            icon: isDarkMode
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined,
            title: localizations.theme,
            trailing: Switch(
              value: isDarkMode,
              onChanged: (val) => themeNotifier.toggleTheme(),
              activeThumbColor: AppColors.primary,
            ),
            onTap: () => themeNotifier.toggleTheme(),
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildSettingItem(
            icon: Icons.notifications_outlined,
            title: localizations.notifications,
            trailing: unreadNotificationCount > 0
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spacingSm,
                          vertical: 2,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: AppDimens.borderRadiusSm,
                        ),
                        child: Text(
                          '$unreadNotificationCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimens.spacingSm),
                      const Icon(Icons.chevron_right, color: AppColors.greyDark),
                    ],
                  )
                : null,
            onTap: () => context.push(AppRoutes.notifications),
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildSettingItem(
            icon: Icons.language_outlined,
            title: localizations.language,
            trailing: Text(
              languageNotifier.currentLanguageName,
              style: const TextStyle(color: AppColors.greyDark),
            ),
            onTap: () =>
                _showLanguageDialog(context, ref, currentLocale, localizations),
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildSettingItem(
            icon: Icons.help_outline,
            title: localizations.helpSupport,
            onTap: () {},
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildSettingItem(
            icon: Icons.info_outline,
            title: localizations.about,
            onTap: () {},
            isLast: true,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    WidgetRef ref,
    Locale currentLocale,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.english),
              value: 'en',
              groupValue: currentLocale.languageCode,
              onChanged: (value) {
                ref
                    .read(languageControllerProvider.notifier)
                    .changeLanguage(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.arabic),
              value: 'ar',
              groupValue: currentLocale.languageCode,
              onChanged: (value) {
                ref
                    .read(languageControllerProvider.notifier)
                    .changeLanguage(const Locale('ar'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
    bool isLast = false,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          bottom: isLast ? const Radius.circular(AppDimens.radiusLg) : Radius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spacingXl,
            vertical: AppDimens.spacingLg,
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: AppDimens.iconMd),
              const SizedBox(width: AppDimens.spacingLg),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
              ),
              trailing ??
                  const Icon(Icons.chevron_right, color: AppColors.greyDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingXl),
      child: Divider(
        height: 1,
        color: isDark
            ? AppColors.greyDark.withValues(alpha: 0.3)
            : AppColors.greyMedium.withValues(alpha: 0.3),
      ),
    );
  }
}
