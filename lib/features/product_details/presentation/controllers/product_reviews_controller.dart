import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';

final productReviewsControllerProvider = StateNotifierProvider.autoDispose.family<
    ProductReviewsController,
    AsyncValue<List<ReviewEntity>>,
    String
>((ref, productId) {
  return ProductReviewsController(ref, productId);
});

final userProductReviewProvider =
    FutureProvider.autoDispose.family<ReviewEntity?, String>((ref, productId) async {
  final user = ref.watch(authControllerProvider).valueOrNull;
  if (user == null) return null;

  final getUserReviewUseCase = ref.watch(getUserProductReviewUseCaseProvider);
  final either = await getUserReviewUseCase(productId);
  return either.fold((_) => null, (review) => review);
});

class ProductReviewsController
    extends StateNotifier<AsyncValue<List<ReviewEntity>>> {
  final Ref _ref;
  final String productId;

  ProductReviewsController(this._ref, this.productId)
      : super(const AsyncValue.loading()) {
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    state = const AsyncValue.loading();
    final either = await _ref.read(getProductReviewsUseCaseProvider)(productId);
    state = either.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (reviews) => AsyncValue.data(reviews),
    );
  }

  Future<bool> submitReview({
    required double rating,
    required String comment,
  }) async {
    final either = await _ref.read(submitReviewUseCaseProvider)(
      productId: productId,
      rating: rating,
      comment: comment,
    );

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
        _ref.invalidate(userProductReviewProvider(productId));
        return true;
      },
    );
  }

  Future<bool> deleteReview(String reviewId) async {
    final either = await _ref.read(deleteReviewUseCaseProvider)(reviewId);
    return either.fold(
      (failure) => false,
      (_) {
        final currentReviews = state.valueOrNull ?? [];
        state = AsyncValue.data(
          currentReviews.where((r) => r.id != reviewId).toList(),
        );
        _ref.invalidate(userProductReviewProvider(productId));
        return true;
      },
    );
  }
}
