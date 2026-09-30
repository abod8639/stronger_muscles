import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/search/domain/repositories/search_repository.dart';

/// Use case for searching products by query.
class SearchProductsUseCase {
  final SearchRepository repository;

  SearchProductsUseCase(this.repository);

  Future<List<ProductModel>> call(String query) {
    return repository.searchProducts(query);
  }
}
