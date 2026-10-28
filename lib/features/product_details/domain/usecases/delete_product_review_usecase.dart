import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product_details/domain/repositories/product_details_repository.dart';

/// Pure Dart use case for deleting a product review.
class DeleteProductReviewUseCase {
  final ProductDetailsRepository _repository;

  const DeleteProductReviewUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String reviewId) {
    return _repository.deleteProductReview(reviewId);
  }
}
