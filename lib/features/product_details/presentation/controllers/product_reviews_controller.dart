import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/features/product/domain/entities/review_entity.dart';
import 'package:stronger_muscles/features/product/domain/usecases/review_usecase_providers.dart';

final productReviewsControllerProvider = StateNotifierProvider.autoDispose.family<
    ProductReviewsController,
    AsyncValue<List<ReviewEntity>>,
    String
>((ref, productId) {
  return ProductReviewsController(ref, productId);
});

final userProductReviewProvider = FutureProvider.autoDispose.family<ReviewEntity?, String>((ref, productId) async {
  final user = ref.watch(authControllerProvider).valueOrNull;
  if (user == null) return null;

  final getUserReviewUseCase = ref.watch(getUserProductReviewUseCaseProvider);
  return getUserReviewUseCase(productId);
});

class ProductReviewsController extends StateNotifier<AsyncValue<List<ReviewEntity>>> {
  final Ref _ref;
  final String productId;

  ProductReviewsController(this._ref, this.productId) : super(const AsyncValue.loading()) {
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    state = const AsyncValue.loading();
    try {
      final reviews = await _ref.read(getProductReviewsUseCaseProvider)(productId);
      state = AsyncValue.data(reviews);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> submitReview({
    required double rating,
    required String comment,
  }) async {
    try {
      final newReview = await _ref.read(submitReviewUseCaseProvider)(
        productId: productId,
        rating: rating,
        comment: comment,
      );

      final currentReviews = state.valueOrNull ?? [];
      final existingIndex = currentReviews.indexWhere((r) => r.id == newReview.id || r.userId == newReview.userId);

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
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteReview(String reviewId) async {
    try {
      await _ref.read(deleteReviewUseCaseProvider)(reviewId);
      final currentReviews = state.valueOrNull ?? [];
      state = AsyncValue.data(
        currentReviews.where((r) => r.id != reviewId).toList(),
      );
      _ref.invalidate(userProductReviewProvider(productId));
      return true;
    } catch (e) {
      return false;
    }
  }
}
