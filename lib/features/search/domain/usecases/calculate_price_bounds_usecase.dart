import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/search/domain/repositories/search_repository.dart';

/// Use case for calculating price bounds (min/max) from a list of products.
class CalculatePriceBoundsUseCase {
  final SearchRepository repository;

  CalculatePriceBoundsUseCase(this.repository);

  Map<String, double> call(List<ProductModel> products) {
    return repository.calculatePriceBounds(products);
  }
}
