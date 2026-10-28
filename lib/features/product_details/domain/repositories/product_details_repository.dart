import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';

/// Pure Dart domain contract for the Product Details feature.
abstract class ProductDetailsRepository {
  /// Fetches complete product details by [productId].
  Future<Either<Failure, ProductEntity>> getProductDetails(String productId);

  /// Fetches paginated reviews for a given [productId].
  Future<Either<Failure, List<ReviewEntity>>> getProductReviews(
    String productId, {
    int page = 1,
  });

  /// Fetches the authenticated user's review for a given [productId] (if available).
  Future<Either<Failure, ReviewEntity?>> getUserProductReview(String productId);

  /// Submits or updates a review for the specified [productId].
  Future<Either<Failure, ReviewEntity>> submitProductReview({
    required String productId,
    required double rating,
    required String comment,
  });

  /// Deletes a user's review by [reviewId].
  Future<Either<Failure, Unit>> deleteProductReview(String reviewId);
}
