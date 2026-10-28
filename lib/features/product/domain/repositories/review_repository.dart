import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/domain/entities/review_entity.dart';

/// Pure domain repository contract defining review operations with functional error handling.
abstract class ReviewRepository {
  /// Fetches paginated reviews for a specific product.
  Future<Either<Failure, List<ReviewEntity>>> getProductReviews(
    String productId, {
    int page = 1,
  });

  /// Fetches the authenticated user's review for a product, if one exists.
  Future<Either<Failure, ReviewEntity?>> getUserProductReview(String productId);

  /// Submits or updates a review for a product.
  Future<Either<Failure, ReviewEntity>> submitReview({
    required String productId,
    required double rating,
    required String comment,
  });

  /// Deletes a review by its ID.
  Future<Either<Failure, Unit>> deleteReview(String reviewId);
}
