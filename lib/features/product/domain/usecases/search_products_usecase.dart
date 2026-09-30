import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/product_repository.dart';

/// Use case to search products by text query.
class SearchProductsUseCase {
  final ProductRepository _repository;

  const SearchProductsUseCase(this._repository);

  Future<List<ProductEntity>> call(String query) {
    return _repository.searchProducts(query);
  }
}
