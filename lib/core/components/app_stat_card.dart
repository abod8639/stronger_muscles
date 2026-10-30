import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_card.dart';
import 'package:stronger_muscles/core/components/app_icon_tile.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Compact tappable metric card: tinted icon, big value, small label.
class AppStatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const AppStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacingSm,
        vertical: AppDimens.spacingLg,
      ),
      borderRadius: AppRadius.allLg,
      boxShadow: context.subtleShadow,
      child: Column(
        children: [
          AppIconTile(icon: icon, color: color, iconSize: 22.0, circular: true),
          const SizedBox(height: AppDimens.spacingSm),
          Text(
            value,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
