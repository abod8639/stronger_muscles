import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/search/domain/repositories/search_repository.dart';

/// Use case for filtering products by price range.
class FilterByPriceUseCase {
  final SearchRepository repository;

  FilterByPriceUseCase(this.repository);

  List<ProductModel> call(List<ProductModel> products, double min, double max) {
    return repository.filterByPrice(products, min, max);
  }
}
