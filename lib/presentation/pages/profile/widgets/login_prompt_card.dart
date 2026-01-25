import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/bindings/profile_controller.dart';
import 'package:stronger_muscles/presentation/pages/auth/auth_view.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/account_settings_list.dart';

class LoginPromptCard extends StatelessWidget {
  const LoginPromptCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ProfileController controller = Get.find<ProfileController>();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Sign in to Your Account',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Track orders, manage addresses, and enjoy a personalized shopping experience',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.greyDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Get.to(() => const AuthView()),
            icon: const Icon(Icons.login),
            label: const Text('Login / Register'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),

          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () async {
              await controller.signInWithGoogle();
            },
            icon: const Icon(Icons.g_mobiledata_outlined, size: 35),
            label: const Text('Sign in with Google'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),

          const SizedBox(height: 20),
          AccountSettingsList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
