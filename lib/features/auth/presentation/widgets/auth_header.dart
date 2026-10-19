import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// A branded header widget for authentication screens.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.fitness_center_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primaryDark, AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: AppRadius.allXl,
            boxShadow: AppShadows.colored(AppColors.primary, alpha: 0.35, blur: 14.0),
          ),
          child: Icon(
            icon,
            color: AppColors.white,
            size: 32.0,
          ),
        ),
        const SizedBox(height: 20.0),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.white : AppColors.black,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.0,
            color: isDark ? AppColors.grey : AppColors.greyDark,
          ),
        ),
      ],
    );
  }
}
