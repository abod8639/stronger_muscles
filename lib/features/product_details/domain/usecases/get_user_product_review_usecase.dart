import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/product_details/domain/repositories/product_details_repository.dart';

/// Pure Dart use case for fetching the logged-in user's review for a product.
class GetUserProductReviewUseCase {
  final ProductDetailsRepository _repository;

  const GetUserProductReviewUseCase(this._repository);

  Future<Either<Failure, ReviewEntity?>> call(String productId) {
    return _repository.getUserProductReview(productId);
  }
}
