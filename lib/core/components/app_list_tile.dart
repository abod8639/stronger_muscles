import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_icon_tile.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Tappable row for settings / menu lists: tinted icon, title, optional
/// subtitle and trailing widget (defaults to a direction-aware chevron).
///
/// Group several inside an `AppCard` separated by dividers.
class AppListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color color;
  final bool showChevron;

  const AppListTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.color = AppColors.primary,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spacingLg,
          vertical: AppDimens.spacingMd,
        ),
        child: Row(
          children: [
            AppIconTile(icon: icon, color: color, iconSize: 20.0),
            const SizedBox(width: AppDimens.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color == AppColors.primary ? context.colorScheme.onSurface : color,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant),
                    ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppDimens.spacingSm),
              trailing!,
            ],
            if (showChevron && onTap != null)
              Icon(Icons.chevron_right_rounded, color: context.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
