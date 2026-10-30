import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_card.dart';
import 'package:stronger_muscles/core/components/app_icon_tile.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// A titled content card (icon + heading + optional trailing action) used to
/// group related information, e.g. "Order summary", "Shipping to".
class AppSectionCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const AppSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.trailing,
    this.padding = const EdgeInsets.all(AppDimens.spacingLg),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: margin,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                AppIconTile(icon: icon!, iconSize: 18.0, padding: 6.0),
                const SizedBox(width: AppDimens.spacingSm),
              ],
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: AppDimens.spacingMd),
          child,
        ],
      ),
    );
  }
}
