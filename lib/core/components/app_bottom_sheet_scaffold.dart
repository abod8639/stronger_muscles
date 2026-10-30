import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/app_bottom_sheet_handle.dart';
import 'package:stronger_muscles/core/components/app_icon_tile.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Standard modal bottom sheet body: drag handle, icon + title + subtitle
/// header, and content that stays above the keyboard.
///
/// Without [heightFactor] the sheet wraps its content and scrolls when tall;
/// with it the sheet takes that fraction of the screen and [child] fills the rest.
class AppBottomSheetScaffold extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final Widget child;
  final double? heightFactor;

  const AppBottomSheetScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.icon,
    this.trailing,
    this.heightFactor,
  });

  /// Opens [builder] as a transparent, scroll-controlled modal bottom sheet.
  static Future<T?> show<T>(BuildContext context, WidgetBuilder builder) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: builder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final textTheme = context.textTheme;

    final header = Row(
      children: [
        if (icon != null) ...[
          AppIconTile(icon: icon!, iconSize: 22.0),
          const SizedBox(width: AppDimens.spacingMd),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleLarge?.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSurface,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2.0),
                Text(
                  subtitle!,
                  style: textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        ?trailing,
      ],
    );

    return Container(
      height: heightFactor == null ? null : mediaQuery.size.height * heightFactor!,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppRadius.topBottomSheet,
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimens.spacingLg + 4,
        AppDimens.spacingMd,
        AppDimens.spacingLg + 4,
        mediaQuery.viewInsets.bottom + AppDimens.spacingLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: BottomSheetHandle()),
          const SizedBox(height: AppDimens.spacingMd),
          header,
          Divider(height: AppDimens.spacingXl, color: context.colorScheme.outlineVariant),
          if (heightFactor == null)
            Flexible(child: SingleChildScrollView(child: child))
          else
            Expanded(child: child),
        ],
      ),
    );
  }
}
