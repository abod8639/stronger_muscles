import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/auth/auth_feature.dart';
import 'package:stronger_muscles/features/product_details/presentation/controllers/product_reviews_controller.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/add_review_bottom_sheet.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/review_card.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Customer reviews: average rating, review list and add/edit-review action.
class ProductReviewsSection extends ConsumerWidget {
  final String productId;

  const ProductReviewsSection({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final reviewsAsync = ref.watch(productReviewsControllerProvider(productId));
    final existingReview = ref.watch(userProductReviewProvider(productId)).valueOrNull;
    final isLoggedIn = ref.watch(authControllerProvider).valueOrNull != null;
    final actionText = existingReview != null ? l10n.editYourReview : l10n.addYourReview;

    void addReview() {
      if (!isLoggedIn) {
        AppSnackBar.showInfo(context, l10n.loginToReview);
        return;
      }
      AddReviewBottomSheet.show(context, productId: productId, existingReview: existingReview);
    }

    final reviews = reviewsAsync.valueOrNull ?? const [];

    return AppSectionCard(
      title: l10n.customerReviews,
      icon: Icons.rate_review_outlined,
      trailing: reviews.isEmpty ? null : AppLinkButton(text: actionText, onPressed: addReview),
      child: reviewsAsync.when(
        data: (reviews) {
          if (reviews.isEmpty) {
            return AppEmptyState(
              fillHeight: false,
              padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingLg),
              icon: Icons.rate_review_outlined,
              title: l10n.noReviewsYet,
              subtitle: l10n.beTheFirstToReviewThisProduct,
              actionText: actionText,
              actionIcon: Icons.edit_note_rounded,
              onActionTap: addReview,
            );
          }

          final average = reviews.fold<double>(0.0, (sum, r) => sum + r.rating) / reviews.length;
          final divider = Divider(
            height: AppDimens.spacingXl,
            color: context.colorScheme.outlineVariant.withValues(alpha: 0.5),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppRatingStars(
                rating: average,
                starSize: 20.0,
                starColor: AppColors.warning,
                showValue: true,
                suffixText: '(${reviews.length} ${l10n.reviews})',
              ),
              for (final review in reviews) ...[divider, ReviewCard(review: review)],
            ],
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: AppDimens.spacingXl),
          child: Center(
            child: SizedBox.square(dimension: 24.0, child: CircularProgressIndicator(strokeWidth: 2.0)),
          ),
        ),
        error: (error, _) => AppAlertCard(
          color: AppColors.error,
          icon: Icons.error_outline_rounded,
          message: l10n.reviewsLoadError,
          actionLabel: l10n.retry,
          onAction: () => ref.invalidate(productReviewsControllerProvider(productId)),
        ),
      ),
    );
  }
}
