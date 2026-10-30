import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Sticky bottom container for primary page actions (checkout, place order,
/// save...). Rounded top corners, top shadow and bottom safe-area handling.
///
/// Use as `Scaffold.bottomNavigationBar`.
class AppBottomActionBar extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const AppBottomActionBar({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(
      AppDimens.spacingLg,
      AppDimens.spacingLg,
      AppDimens.spacingLg,
      AppDimens.spacingMd,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppRadius.top(AppRadius.xl),
        boxShadow: context.topBarShadow,
      ),
      child: SafeArea(
        top: false,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
