import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/app_bottom_sheet_handle.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/product_details/presentation/controllers/product_reviews_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

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
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddReviewBottomSheet(
        productId: productId,
        existingReview: existingReview,
      ),
    );
  }

  @override
  ConsumerState<AddReviewBottomSheet> createState() =>
      _AddReviewBottomSheetState();
}

class _AddReviewBottomSheetState extends ConsumerState<AddReviewBottomSheet> {
  late double _rating;
  late TextEditingController _commentController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.existingReview?.rating ?? 5.0;
    _commentController = TextEditingController(
      text: widget.existingReview?.comment ?? '',
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await ref
        .read(productReviewsControllerProvider(widget.productId).notifier)
        .submitReview(
          rating: _rating,
          comment: _commentController.text.trim(),
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.existingReview != null
                ? 'تم تحديث التقييم بنجاح'
                : 'تمت إضافة التقييم بنجاح',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء حفظ التقييم، يرجى المحاولة مرة أخرى'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final intl = AppLocalizations.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: bottomInset + 20,
      ),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: AppRadius.topBottomSheet,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: AppBottomSheetHandle(),
                ),
              ),

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.existingReview != null
                        ? 'تعديل التقييم'
                        : (intl?.customerReviews ?? 'أضف تقييمك'),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Interactive Stars
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    final starValue = (index + 1).toDouble();
                    return IconButton(
                      iconSize: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      icon: Icon(
                        starValue <= _rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: starValue <= _rating
                            ? Colors.amber
                            : Colors.grey.withValues(alpha: 0.4),
                      ),
                      onPressed: () {
                        setState(() => _rating = starValue);
                      },
                    );
                  }),
                ),
              ),

              Center(
                child: Text(
                  '${_rating.toStringAsFixed(1)} / 5.0',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Comment text area
              TextFormField(
                controller: _commentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'اكتب تجربتك مع هذا المنتج...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
                      : Colors.grey.shade100,
                  border: const OutlineInputBorder(
                    borderRadius: AppRadius.allMd,
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: AppRadius.allMd,
                    borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'يرجى كتابة تعليق لوصف تجربتك';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: AppRadius.shapeMd,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.existingReview != null
                              ? 'تحديث التقييم'
                              : 'إرسال التقييم',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
