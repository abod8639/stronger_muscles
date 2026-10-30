import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/product_details/presentation/controllers/product_reviews_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Sheet for adding or editing the current user's review of a product.
class AddReviewBottomSheet extends ConsumerStatefulWidget {
  final String productId;
  final ReviewEntity? existingReview;

  const AddReviewBottomSheet({
    super.key,
    required this.productId,
    this.existingReview,
  });

  static Future<void> show(
    BuildContext context, {
    required String productId,
    ReviewEntity? existingReview,
  }) =>
      AppBottomSheetScaffold.show<void>(
        context,
        (_) => AddReviewBottomSheet(productId: productId, existingReview: existingReview),
      );

  @override
  ConsumerState<AddReviewBottomSheet> createState() => _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends ConsumerState<AddReviewBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late double _rating = widget.existingReview?.rating ?? 5.0;
  late final _commentController = TextEditingController(text: widget.existingReview?.comment ?? '');
  bool _isLoading = false;

  bool get _isEditing => widget.existingReview != null;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading || !_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() => _isLoading = true);
    final success = await ref
        .read(productReviewsControllerProvider(widget.productId).notifier)
        .submitReview(rating: _rating, comment: _commentController.text.trim());

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pop();
      AppSnackBar.showSuccess(context, _isEditing ? l10n.reviewUpdated : l10n.reviewAdded);
    } else {
      AppSnackBar.showError(context, l10n.reviewSaveFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppBottomSheetScaffold(
      icon: Icons.rate_review_outlined,
      title: _isEditing ? l10n.editYourReview : l10n.addYourReview,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var star = 1; star <= 5; star++)
                  IconButton(
                    iconSize: 36.0,
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    onPressed: () => setState(() => _rating = star.toDouble()),
                    icon: Icon(
                      star <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: star <= _rating ? AppColors.warning : context.colorScheme.outlineVariant,
                    ),
                  ),
              ],
            ),
            Text(
              '${_rating.toStringAsFixed(1)} / 5.0',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimens.spacingLg + 4),
            AppTextFormField(
              controller: _commentController,
              hintText: l10n.writeYourExperience,
              minLines: 4,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              validator: (value) =>
                  value == null || value.trim().isEmpty ? l10n.reviewCommentRequired : null,
            ),
            const SizedBox(height: AppDimens.spacingXl),
            AppPrimaryButton(
              text: _isEditing ? l10n.updateReview : l10n.submitReview,
              icon: Icons.send_rounded,
              height: 52.0,
              isLoading: _isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
