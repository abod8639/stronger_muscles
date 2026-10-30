import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// A branded page header: gradient icon tile, title and subtitle.
///
/// Used on auth, onboarding and any full-screen intro section.
class AppHeroHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final double iconTileSize;
  final List<Color> gradientColors;

  const AppHeroHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.fitness_center_rounded,
    this.iconTileSize = 72.0,
    this.gradientColors = const [AppColors.primaryDark, AppColors.primary],
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconTileSize,
          height: iconTileSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
            ),
            borderRadius: AppRadius.allXl,
            boxShadow: AppShadows.colored(gradientColors.last, alpha: 0.35, blur: 20),
          ),
          child: Icon(icon, color: AppColors.white, size: iconTileSize * 0.48),
        ),
        const SizedBox(height: 24.0),
        Text(
          title,
          textAlign: TextAlign.center,
          style: textTheme.displayMedium?.copyWith(
            color: context.colorScheme.onSurface,
            letterSpacing: -0.3,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8.0),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}
