import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';

/// Displays a price in the app currency, with the struck-through original
/// price next to it (or below it) when [originalPrice] is higher.
class AppPriceText extends StatelessWidget {
  final double price;
  final double? originalPrice;
  final double fontSize;
  final Color? color;
  final Axis direction;
  final int decimals;

  const AppPriceText({
    super.key,
    required this.price,
    this.originalPrice,
    this.fontSize = 15.0,
    this.color,
    this.direction = Axis.horizontal,
    this.decimals = 2,
  });

  /// Formats [value] with the app currency prefix, e.g. `LE 120.00`.
  static String format(double value, {int decimals = 2}) =>
      'LE ${value.toStringAsFixed(decimals)}';

  @override
  Widget build(BuildContext context) {
    final original = originalPrice;
    final hasDiscount = original != null && original > price;
    final isHorizontal = direction == Axis.horizontal;

    return Wrap(
      direction: direction,
      spacing: isHorizontal ? 8.0 : 0.0,
      crossAxisAlignment:
          isHorizontal ? WrapCrossAlignment.center : WrapCrossAlignment.start,
      children: [
        Text(
          format(price, decimals: decimals),
          style: context.textTheme.titleMedium?.copyWith(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color ?? AppColors.primary,
          ),
        ),
        if (hasDiscount)
          Text(
            format(original, decimals: decimals),
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: fontSize * 0.8,
              fontWeight: FontWeight.w500,
              color: context.colorScheme.onSurfaceVariant,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }
}
