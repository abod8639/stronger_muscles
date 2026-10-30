import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_icon_tile.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Brand gradient hero banner with icon, title, subtitle and an optional
/// widget below (e.g. a search field).
class AppGradientBanner extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? child;

  const AppGradientBanner({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textTheme = context.textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.spacingLg + 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? const [AppColors.surfaceDark, Color(0xFF2A1515)]
              : const [AppColors.primaryDark, AppColors.primary],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        borderRadius: AppRadius.allXl,
        boxShadow: AppShadows.colored(
          isDark ? Colors.black : AppColors.primary,
          alpha: isDark ? 0.35 : 0.25,
          blur: 18.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                AppIconTile(
                  icon: icon!,
                  color: AppColors.white,
                  backgroundColor: AppColors.white.withValues(alpha: 0.15),
                  iconSize: 28.0,
                  padding: 10.0,
                  circular: true,
                ),
                const SizedBox(width: 14.0),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleLarge?.copyWith(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3.0),
                      Text(
                        subtitle!,
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 13.0,
                          color: AppColors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (child != null) ...[
            const SizedBox(height: AppDimens.spacingLg + 4),
            child!,
          ],
        ],
      ),
    );
  }
}
