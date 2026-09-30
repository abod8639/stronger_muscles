import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/components/rating_stars.dart';
import 'package:stronger_muscles/features/product/data/models/review_model.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class StarsRecord extends StatelessWidget {
  final List<ReviewModel> reviews;

  const StarsRecord({super.key, required this.reviews});

  /// Calculate average rating from reviews list
  double _calculateAverageRating() {
    if (reviews.isEmpty) return 0.0;

    final totalRating = reviews.fold<double>(
      0.0,
      (sum, review) => sum + review.rating,
    );

    return totalRating / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final averageRating = _calculateAverageRating();
    final actualReviewCount = reviews.length;
    final intl10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.spacingLg),
      child: RatingStars(
        rating: averageRating,
        starSize: 20.0,
        showValue: true,
        suffixText: '($actualReviewCount ${intl10n.reviews})',
        textStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

