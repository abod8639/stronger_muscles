import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/search/domain/repositories/search_repository.dart';

/// Use case for filtering products by price range.
class FilterByPriceUseCase {
  final SearchRepository repository;

  FilterByPriceUseCase(this.repository);

  List<ProductEntity> call(
    List<ProductEntity> products,
    double min,
    double max,
  ) {
    return repository.filterByPrice(products, min, max);
  }
}
