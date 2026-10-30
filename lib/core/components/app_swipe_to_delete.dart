import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Swipe (end → start) to delete wrapper with a consistent red background
/// that matches the card's rounded corners and margin.
class AppSwipeToDelete extends StatelessWidget {
  final Key dismissKey;
  final VoidCallback onDeleted;
  final Widget child;
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry? borderRadius;

  const AppSwipeToDelete({
    super.key,
    required this.dismissKey,
    required this.onDeleted,
    required this.child,
    this.margin = EdgeInsets.zero,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: dismissKey,
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDeleted(),
      background: Container(
        margin: margin,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        alignment: AlignmentDirectional.centerEnd,
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: borderRadius ?? AppRadius.allLg,
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.white),
      ),
      child: child,
    );
  }
}
