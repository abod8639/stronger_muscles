import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';

/// One customer review: initial avatar, name, date, star badge and comment.
class ReviewCard extends StatelessWidget {
  final ReviewEntity review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final locale = Localizations.localeOf(context).languageCode;
    final name = review.userName;
    final photoUrl = review.userPhotoUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (photoUrl != null && photoUrl.isNotEmpty)
              AppNetworkImage(
                imageUrl: photoUrl,
                width: 40.0,
                height: 40.0,
                borderRadius: AppRadius.allPill,
                errorIcon: Icons.person_outline_rounded,
              )
            else
              CircleAvatar(
                radius: 20.0,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: AppDimens.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    DateFormat.yMMMd(locale).format(review.createdAt),
                    style: textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            AppBadge(
              icon: Icons.star_rounded,
              label: review.rating.toStringAsFixed(1),
              color: AppColors.warning,
            ),
          ],
        ),
        if (review.comment.isNotEmpty) ...[
          const SizedBox(height: AppDimens.spacingSm),
          Text(
            review.comment,
            style: textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}
