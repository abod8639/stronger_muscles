import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/product_details/domain/repositories/product_details_repository.dart';

/// Pure Dart use case for fetching product details.
class GetProductDetailsUseCase {
  final ProductDetailsRepository _repository;

  const GetProductDetailsUseCase(this._repository);

  Future<Either<Failure, ProductEntity>> call(String productId) {
    return _repository.getProductDetails(productId);
  }
}
