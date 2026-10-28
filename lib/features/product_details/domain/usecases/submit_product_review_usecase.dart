import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/product_details/domain/repositories/product_details_repository.dart';

/// Pure Dart use case for submitting or updating a product review.
class SubmitProductReviewUseCase {
  final ProductDetailsRepository _repository;

  const SubmitProductReviewUseCase(this._repository);

  Future<Either<Failure, ReviewEntity>> call({
    required String productId,
    required double rating,
    required String comment,
  }) {
    return _repository.submitProductReview(
      productId: productId,
      rating: rating,
      comment: comment,
    );
  }
}
