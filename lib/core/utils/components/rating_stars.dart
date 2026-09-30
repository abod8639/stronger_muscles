import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';

/// A reusable star rating display widget.
/// Renders full, half, and empty stars based on a double rating out of 5.0.
class RatingStars extends StatelessWidget {
  final double rating;
  final double starSize;
  final Color starColor;
  final Color emptyColor;
  final bool showValue;
  final String? suffixText;
  final TextStyle? textStyle;
  final double spacing;

  const RatingStars({
    super.key,
    required this.rating,
    this.starSize = 18.0,
    this.starColor = Colors.amber,
    this.emptyColor = Colors.grey,
    this.showValue = false,
    this.suffixText,
    this.textStyle,
    this.spacing = AppDimens.spacingXs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clampedRating = rating.clamp(0.0, 5.0);
    final fullStars = clampedRating.floor();
    final hasHalfStar = (clampedRating - fullStars) >= 0.5;
    final emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (var i = 0; i < fullStars; i++)
          Icon(Icons.star_rounded, color: starColor, size: starSize),
        if (hasHalfStar)
          Icon(Icons.star_half_rounded, color: starColor, size: starSize),
        for (var i = 0; i < emptyStars; i++)
          Icon(Icons.star_outline_rounded, color: emptyColor, size: starSize),
        if (showValue || suffixText != null) ...[
          SizedBox(width: spacing),
          Text(
            [
              if (showValue) clampedRating.toStringAsFixed(1),
              if (suffixText != null) suffixText!,
            ].join(' '),
            style: textStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ],
    );
  }
}
