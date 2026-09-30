import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/product_repository.dart';

/// Use case to fetch products with optional category and pagination filtering.
class GetProductsUseCase {
  final ProductRepository _repository;

  const GetProductsUseCase(this._repository);

  Future<List<ProductEntity>> call({String? categoryId, int page = 1}) {
    return _repository.getProducts(categoryId: categoryId, page: page);
  }
}
