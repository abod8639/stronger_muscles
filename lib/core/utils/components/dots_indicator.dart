import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';

/// A reusable animated dot indicator for PageViews, carousels, and image sliders.
class DotsIndicator extends StatelessWidget {
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

  const DotsIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.dotHeight = 5.0,
    this.activeDotWidth = 15.0,
    this.inactiveDotWidth = 5.0,
    this.activeColor,
    this.inactiveColor,
    this.margin = const EdgeInsets.symmetric(horizontal: 3.0),
    this.borderRadius = AppDimens.borderRadiusXs,
    this.duration = const Duration(milliseconds: 300),
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount <= 1) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final effectiveActiveColor = activeColor ?? AppColors.primary;
    final effectiveInactiveColor = inactiveColor ??
        (theme.brightness == Brightness.dark
            ? AppColors.greyDark
            : Colors.grey.shade400);

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
