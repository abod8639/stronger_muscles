import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/product_repository.dart';

/// Pure Dart UseCase to fetch products with optional category filtering and pagination.
class GetProductsUseCase {
  final ProductRepository _repository;

  const GetProductsUseCase(this._repository);

  Future<Either<Failure, List<ProductEntity>>> call({
    String? categoryId,
    int page = 1,
    int limit = 20,
  }) {
    return _repository.getProducts(
      categoryId: categoryId,
      page: page,
      limit: limit,
    );
  }
}
