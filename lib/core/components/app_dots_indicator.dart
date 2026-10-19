import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Reusable animated dot indicator for carousels, page views, and sliders.
class AppDotsIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final double dotHeight;
  final double activeDotWidth;
  final double inactiveDotWidth;
  final Color? activeColor;
  final Color? inactiveColor;
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry borderRadius;
  final Duration duration;
  final MainAxisAlignment alignment;

  const AppDotsIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.dotHeight = 4.0,
    this.activeDotWidth = 16.0,
    this.inactiveDotWidth = 4.0,
    this.activeColor,
    this.inactiveColor,
    this.margin = const EdgeInsets.symmetric(horizontal: 2.0),
    this.borderRadius = AppRadius.allXs,
    this.duration = const Duration(milliseconds: 200),
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount <= 1) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final effectiveActiveColor = activeColor ?? theme.colorScheme.primary;
    final effectiveInactiveColor = inactiveColor ??
        (theme.brightness == Brightness.dark
            ? AppColors.greyDark
            : theme.colorScheme.primary.withAlpha(100));

    return Row(
      mainAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        itemCount,
        (index) {
          final isActive = currentIndex == index;
          return AnimatedContainer(
            duration: duration,
            margin: margin,
            height: dotHeight,
            width: isActive ? activeDotWidth : inactiveDotWidth,
            decoration: BoxDecoration(
              color: isActive ? effectiveActiveColor : effectiveInactiveColor,
              borderRadius: borderRadius,
            ),
          );
        },
      ),
    );
  }
}
