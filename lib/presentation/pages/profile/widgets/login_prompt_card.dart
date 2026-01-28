import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/functions/app_guard.dart';
import 'package:stronger_muscles/presentation/controllers/profile_controller.dart';
import 'package:stronger_muscles/presentation/pages/auth/auth_view.dart';
import 'package:stronger_muscles/presentation/pages/profile/widgets/account_settings_list.dart';

const String _loginTitle = 'Sign in to Your Account';
const String _loginMessage = 'Track orders, manage addresses, and enjoy a personalized shopping experience';
const String _loginButtonLabel = 'Login / Register';
const String _googleButtonLabel = 'Sign in with Google';
const double _containerMargin = 16.0;
const double _containerPadding = 32.0;
const double _containerBorderRadius = 20.0;
// const double _containerElevation = 0.0;
const double _iconBackgroundSize = 20.0;
const double _iconSize = 60.0;
const double _titleIconSpacing = 24.0;
const double _messageSpacing = 12.0;
const double _buttonsSpacing = 20.0;
const double _buttonBorderRadius = 12.0;
const double _googleIconSize = 35.0;
const double _buttonElevation = 2.0;
const double _googleButtonPaddingHorizontal = 25.0;
const double _googleButtonPaddingVertical = 10.0;

class LoginPromptCard extends StatelessWidget {
  const LoginPromptCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ProfileController controller = Get.find<ProfileController>();

    return Container(
      margin: const EdgeInsets.all(_containerMargin),
      padding: const EdgeInsets.all(_containerPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(_containerBorderRadius),
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
            padding: const EdgeInsets.all(_iconBackgroundSize),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: _iconSize,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: _titleIconSpacing),
          Text(
            _loginTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.white : AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: _messageSpacing),
          Text(
            _loginMessage,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.greyDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: _buttonsSpacing),
          ElevatedButton.icon(
            onPressed: () => _handleLogin(),
            icon: const Icon(Icons.login),
            label: const Text(_loginButtonLabel),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_buttonBorderRadius),
              ),
              elevation: _buttonElevation,
            ),
          ),

          const SizedBox(height: _buttonsSpacing),
          ElevatedButton.icon(
            onPressed: () async {
              
              await controller.signInWithGoogle();
            },
            icon: const Icon(Icons.g_mobiledata_outlined, size: _googleIconSize),
            label: const Text(_googleButtonLabel),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: _googleButtonPaddingHorizontal,
                vertical: _googleButtonPaddingVertical,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_buttonBorderRadius),
              ),
              elevation: _buttonElevation,
            ),
          ),

          const SizedBox(height: _buttonsSpacing),
          const AccountSettingsList(),
          const SizedBox(height: _buttonsSpacing),
        ],
      ),
    );
  }
}

Future<void> _handleLogin() async {
  return AuthGuard.runIfConnectedAndAuthenticated(
    () async => Get.to(
      () => const AuthView()
    )
  );
}
