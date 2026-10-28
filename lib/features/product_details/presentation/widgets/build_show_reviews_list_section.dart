import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/data/models/review_model.dart';
import 'package:stronger_muscles/features/product_details/presentation/controllers/product_reviews_controller.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/add_review_bottom_sheet.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/show_reviews_list.dart';

/// Builds the reviews list section connected with Riverpod and the database backend.
Widget buildShowReviewsListSection(ProductModel product) {
  return Consumer(
    builder: (context, ref, child) {
      final reviewsAsync = ref.watch(productReviewsControllerProvider(product.id));
      final userReviewAsync = ref.watch(userProductReviewProvider(product.id));
      final currentUser = ref.watch(authControllerProvider).valueOrNull;

      final existingUserReview = userReviewAsync.valueOrNull;
      final actionText = existingUserReview != null ? 'تعديل تقييمك' : 'أضف تقييمك';

      void handleAddReview() {
        if (currentUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('يرجى تسجيل الدخول أولاً لإضافة تقييم'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        AddReviewBottomSheet.show(
          context,
          productId: product.id,
          existingReview: existingUserReview,
        );
      }

      return reviewsAsync.when(
        data: (entities) {
          final reviews = entities.map((e) => ReviewModel.fromEntity(e)).toList();
          return ShowReviewsList(
            reviews: reviews,
            onAddReview: handleAddReview,
            actionText: actionText,
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        error: (error, stack) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تعذر تحميل التقييمات',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.red),
              ),
              TextButton(
                onPressed: () {
                  ref.invalidate(productReviewsControllerProvider(product.id));
                },
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
