import 'package:stronger_muscles/features/product/domain/entities/review_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/review_repository.dart';

/// Use case to fetch reviews for a specific product.
class GetProductReviewsUseCase {
  final ReviewRepository _repository;

  const GetProductReviewsUseCase(this._repository);

  Future<List<ReviewEntity>> call(String productId, {int page = 1}) {
    return _repository.getProductReviews(productId, page: page);
  }
}

/// Use case to get the authenticated user's review for a product.
class GetUserProductReviewUseCase {
  final ReviewRepository _repository;

  const GetUserProductReviewUseCase(this._repository);

  Future<ReviewEntity?> call(String productId) {
    return _repository.getUserProductReview(productId);
  }
}

/// Use case to submit or update a review.
class SubmitReviewUseCase {
  final ReviewRepository _repository;

  const SubmitReviewUseCase(this._repository);

  Future<ReviewEntity> call({
    required String productId,
    required double rating,
    required String comment,
  }) {
    return _repository.submitReview(
      productId: productId,
      rating: rating,
      comment: comment,
    );
  }
}

/// Use case to delete a review.
class DeleteReviewUseCase {
  final ReviewRepository _repository;

  const DeleteReviewUseCase(this._repository);

  Future<void> call(String reviewId) {
    return _repository.deleteReview(reviewId);
  }
}
