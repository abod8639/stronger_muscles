import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/product_repository.dart';

/// Pure Dart UseCase to retrieve locally cached products synchronously.
class GetCachedProductsUseCase {
  final ProductRepository _repository;

  const GetCachedProductsUseCase(this._repository);

  Either<Failure, List<ProductEntity>> call() {
    return _repository.getCachedProducts();
  }
}
