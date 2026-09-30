import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/product_repository.dart';

/// Use case to retrieve locally cached products synchronously.
class GetCachedProductsUseCase {
  final ProductRepository _repository;

  const GetCachedProductsUseCase(this._repository);

  List<ProductEntity> call() {
    return _repository.getCachedProducts();
  }
}
