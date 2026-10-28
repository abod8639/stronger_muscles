import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/domain/entities/review_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/review_repository.dart';

/// Pure Dart UseCase to fetch paginated reviews for a product.
class GetProductReviewsUseCase {
  final ReviewRepository _repository;

  const GetProductReviewsUseCase(this._repository);

  Future<Either<Failure, List<ReviewEntity>>> call(
    String productId, {
    int page = 1,
  }) {
    return _repository.getProductReviews(productId, page: page);
  }
}

/// Pure Dart UseCase to fetch the authenticated user's review for a product.
class GetUserProductReviewUseCase {
  final ReviewRepository _repository;

  const GetUserProductReviewUseCase(this._repository);

  Future<Either<Failure, ReviewEntity?>> call(String productId) {
    return _repository.getUserProductReview(productId);
  }
}

/// Pure Dart UseCase to submit or update a product review.
class SubmitReviewUseCase {
  final ReviewRepository _repository;

  const SubmitReviewUseCase(this._repository);

  Future<Either<Failure, ReviewEntity>> call({
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

/// Pure Dart UseCase to delete a product review.
class DeleteReviewUseCase {
  final ReviewRepository _repository;

  const DeleteReviewUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String reviewId) {
    return _repository.deleteReview(reviewId);
  }
}
