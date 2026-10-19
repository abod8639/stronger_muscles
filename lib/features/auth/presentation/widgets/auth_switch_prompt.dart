import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Reusable prompt row to navigate between Sign In and Sign Up.
class AuthSwitchPrompt extends StatelessWidget {
  final String promptText;
  final String actionText;
  final VoidCallback? onActionTap;

  const AuthSwitchPrompt({
    super.key,
    required this.promptText,
    required this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          promptText,
          style: TextStyle(
            fontSize: 14.0,
            color: isDark ? AppColors.grey : AppColors.greyDark,
          ),
        ),
        TextButton(
          onPressed: onActionTap,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
          ),
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
