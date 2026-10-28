import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/search/domain/repositories/search_repository.dart';

/// Pure domain use case for searching products by query.
class SearchProductsUseCase {
  final SearchRepository repository;

  const SearchProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call(String query) {
    return repository.searchProducts(query);
  }
}
