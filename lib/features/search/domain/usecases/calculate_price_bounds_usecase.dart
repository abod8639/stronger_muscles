import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/search/domain/entities/price_bounds.dart';
import 'package:stronger_muscles/features/search/domain/repositories/search_repository.dart';

/// Pure domain use case for calculating price bounds (min/max) from a list of products.
class CalculatePriceBoundsUseCase {
  final SearchRepository repository;

  const CalculatePriceBoundsUseCase(this.repository);

  PriceBounds call(List<ProductEntity> products) {
    return repository.calculatePriceBounds(products);
  }
}
