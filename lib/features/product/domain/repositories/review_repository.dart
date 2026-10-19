import 'package:stronger_muscles/features/product/domain/entities/review_entity.dart';

/// Domain contract defining review data operations.
abstract class ReviewRepository {
  /// Fetches paginated reviews for a specific product.
  Future<List<ReviewEntity>> getProductReviews(String productId, {int page = 1});

  /// Fetches the authenticated user's review for a product, if one exists.
  Future<ReviewEntity?> getUserProductReview(String productId);

  /// Submits or updates a review for a product.
  Future<ReviewEntity> submitReview({
    required String productId,
    required double rating,
    required String comment,
  });

  /// Deletes a review by its ID.
  Future<void> deleteReview(String reviewId);
}
