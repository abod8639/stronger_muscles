import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/controllers/theme_controller.dart';
import 'package:stronger_muscles/presentation/controllers/language_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

const double _containerMarginHorizontal = 16.0;
const double _containerBorderRadius = 16.0;
const double _containerPadding = 20.0;
const double _shadowOpacity = 0.05;
const double _shadowBlurRadius = 10.0;
const double _shadowOffsetY = 4.0;

class AccountSettingsList extends StatelessWidget {
  const AccountSettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = Get.find<ThemeController>();
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _containerMarginHorizontal),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(_containerBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(_shadowOpacity),
            blurRadius: _shadowBlurRadius,
            offset: const Offset(0, _shadowOffsetY),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(_containerPadding),
            child: Text(
              AppLocalizations.of(context)!.accountSettings,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
          ),
          _buildSettingItem(
            icon: Icons.person_outline,
            title: AppLocalizations.of(context)!.editProfile,
            onTap: () {
              Get.toNamed(AppRoutes.editUserInfo);
            },
            isDark: isDark,
          ),
          _buildDivider(isDark),
          Obx(
            () => _buildSettingItem(
              icon: themeController.isDarkMode.value
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              title: AppLocalizations.of(context)!.theme,
              trailing: Switch(
                value: themeController.isDarkMode.value,
                onChanged: (val) => themeController.toggleTheme(),
                activeThumbColor: AppColors.primary,
              ),
              onTap: () => themeController.toggleTheme(),
              isDark: isDark,
            ),
          ),
          _buildDivider(isDark),
          _buildSettingItem(
            icon: Icons.notifications_outlined,
            title: AppLocalizations.of(context)!.notifications,
            onTap: () {},
            isDark: isDark,
          ),

          _buildDivider(isDark),

          _buildSettingItem(
            icon: Icons.language_outlined,
            title: AppLocalizations.of(context)!.language,
            trailing: Obx(() {
              final languageController = Get.find<LanguageController>();
              return Text(
                languageController.currentLanguageName,
                style: const TextStyle(color: AppColors.greyDark),
              );
            }),
            onTap: () => _showLanguageDialog(context),
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildSettingItem(
            icon: Icons.help_outline,
            title: AppLocalizations.of(context)!.helpSupport,
            onTap: () {},
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildSettingItem(
            icon: Icons.info_outline,
            title: AppLocalizations.of(context)!.about,
            onTap: () {},
            isLast: true,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.language),
        content: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text(AppLocalizations.of(context)!.english),
                value: 'en',
                groupValue: languageController.currentLocale.value.languageCode,
                onChanged: (value) {
                  languageController.changeLanguage(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: Text(AppLocalizations.of(context)!.arabic),
                value: 'ar',
                groupValue: languageController.currentLocale.value.languageCode,
                onChanged: (value) {
                  languageController.changeLanguage(const Locale('ar'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
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
          bottom: isLast ? const Radius.circular(16) : Radius.zero,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 16),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        height: 1,
        color: isDark
            ? AppColors.greyDark.withOpacity(0.3)
            : AppColors.greyMedium.withOpacity(0.3),
      ),
    );
  }
}
