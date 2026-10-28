import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/product_details/domain/repositories/product_details_repository.dart';

/// Pure Dart use case for fetching product reviews.
class GetProductReviewsUseCase {
  final ProductDetailsRepository _repository;

  const GetProductReviewsUseCase(this._repository);

  Future<Either<Failure, List<ReviewEntity>>> call(
    String productId, {
    int page = 1,
  }) {
    return _repository.getProductReviews(productId, page: page);
  }
}
