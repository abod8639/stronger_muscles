import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/bindings/theme_controller.dart';

class AccountSettingsList extends StatelessWidget {
  final ThemeData theme;

  const AccountSettingsList({
    super.key,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Account Settings',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.white : AppColors.black,
              ),
            ),
          ),
          _buildSettingItem(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () {},
            isDark: isDark,
          ),
          _buildDivider(isDark),
          Obx(() => _buildSettingItem(
            icon: themeController.isDarkMode.value 
                ? Icons.dark_mode_outlined 
                : Icons.light_mode_outlined,
            title: 'Theme',
            trailing: Switch(
              value: themeController.isDarkMode.value,
              onChanged: (val) => themeController.toggleTheme(),
              activeColor: AppColors.primary,
            ),
            onTap: () => themeController.toggleTheme(),
            isDark: isDark,
          )),
          _buildDivider(isDark),
          _buildSettingItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {},
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildSettingItem(
            icon: Icons.language_outlined,
            title: 'Language',
            trailing: const Text('English', style: TextStyle(color: AppColors.greyDark)),
            onTap: () {},
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildSettingItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {},
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildSettingItem(
            icon: Icons.info_outline,
            title: 'About',
            onTap: () {},
            isLast: true,
            isDark: isDark,
          ),
        ],
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
              trailing ?? const Icon(Icons.chevron_right, color: AppColors.greyDark),
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
        color: isDark ? AppColors.greyDark.withOpacity(0.3) : AppColors.greyMedium.withOpacity(0.3),
      ),
    );
  }
}
