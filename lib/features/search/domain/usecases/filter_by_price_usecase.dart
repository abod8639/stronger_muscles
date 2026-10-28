import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/search/domain/repositories/search_repository.dart';

/// Pure domain use case for filtering products by price range.
class FilterByPriceUseCase {
  final SearchRepository repository;

  const FilterByPriceUseCase(this.repository);

  List<ProductEntity> call(
    List<ProductEntity> products,
    double min,
    double max,
  ) {
    return repository.filterByPrice(products, min, max);
  }
}
