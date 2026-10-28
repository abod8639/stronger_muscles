import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/auth/auth_feature.dart';
import 'package:stronger_muscles/features/product/product_feature.dart'
    hide
        getProductReviewsUseCaseProvider,
        getUserProductReviewUseCaseProvider,
        submitReviewUseCaseProvider,
        deleteReviewUseCaseProvider,
        GetProductReviewsUseCase,
        GetUserProductReviewUseCase,
        SubmitReviewUseCase,
        DeleteReviewUseCase;
import 'package:stronger_muscles/features/product_details/domain/usecases/delete_product_review_usecase.dart';
import 'package:stronger_muscles/features/product_details/domain/usecases/get_product_reviews_usecase.dart';
import 'package:stronger_muscles/features/product_details/domain/usecases/submit_product_review_usecase.dart';
import 'package:stronger_muscles/features/product_details/product_details_providers.dart';

final productReviewsControllerProvider = StateNotifierProvider.autoDispose.family<
    ProductReviewsController,
    AsyncValue<List<ReviewEntity>>,
    String
>((ref, productId) {
  return ProductReviewsController(
    getReviewsUseCase: ref.watch(getProductReviewsUseCaseProvider),
    submitReviewUseCase: ref.watch(submitProductReviewUseCaseProvider),
    deleteReviewUseCase: ref.watch(deleteProductReviewUseCaseProvider),
    productId: productId,
    onInvalidateUserReview: () {
      ref.invalidate(userProductReviewProvider(productId));
    },
  );
});

final userProductReviewProvider =
    FutureProvider.autoDispose.family<ReviewEntity?, String>((ref, productId) async {
  final user = ref.watch(authControllerProvider).valueOrNull;
  if (user == null) return null;

  final getUserReviewUseCase = ref.watch(getUserProductReviewUseCaseProvider);
  final either = await getUserReviewUseCase(productId);
  return either.fold((_) => null, (review) => review);
});

/// Controller handling reviews state and submission guards for a product.
class ProductReviewsController
    extends StateNotifier<AsyncValue<List<ReviewEntity>>> {
  final GetProductReviewsUseCase _getReviewsUseCase;
  final SubmitProductReviewUseCase _submitReviewUseCase;
  final DeleteProductReviewUseCase _deleteReviewUseCase;
  final String productId;
  final VoidCallback? onInvalidateUserReview;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  ProductReviewsController({
    required GetProductReviewsUseCase getReviewsUseCase,
    required SubmitProductReviewUseCase submitReviewUseCase,
    required DeleteProductReviewUseCase deleteReviewUseCase,
    required this.productId,
    this.onInvalidateUserReview,
  })  : _getReviewsUseCase = getReviewsUseCase,
        _submitReviewUseCase = submitReviewUseCase,
        _deleteReviewUseCase = deleteReviewUseCase,
        super(const AsyncValue.loading()) {
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    state = const AsyncValue.loading();
    final either = await _getReviewsUseCase(productId);
    state = either.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (reviews) => AsyncValue.data(reviews),
    );
  }

  /// Submits a review with guard clauses against duplicate submissions.
  Future<bool> submitReview({
    required double rating,
    required String comment,
  }) async {
    if (_isSubmitting) return false;
    _isSubmitting = true;

    final either = await _submitReviewUseCase(
      productId: productId,
      rating: rating,
      comment: comment,
    );

    _isSubmitting = false;

    return either.fold(
      (failure) => false,
      (newReview) {
        final currentReviews = state.valueOrNull ?? [];
        final existingIndex = currentReviews.indexWhere(
          (r) => r.id == newReview.id || r.userId == newReview.userId,
        );

        List<ReviewEntity> updatedList;
        if (existingIndex >= 0) {
          updatedList = List.from(currentReviews);
          updatedList[existingIndex] = newReview;
        } else {
          updatedList = [newReview, ...currentReviews];
        }

        state = AsyncValue.data(updatedList);
        onInvalidateUserReview?.call();
        return true;
      },
    );
  }

  /// Deletes a review by [reviewId] with guard clauses.
  Future<bool> deleteReview(String reviewId) async {
    if (_isSubmitting) return false;
    _isSubmitting = true;

    final either = await _deleteReviewUseCase(reviewId);

    _isSubmitting = false;

    return either.fold(
      (failure) => false,
      (_) {
        final currentReviews = state.valueOrNull ?? [];
        state = AsyncValue.data(
          currentReviews.where((r) => r.id != reviewId).toList(),
        );
        onInvalidateUserReview?.call();
        return true;
      },
    );
  }
}
