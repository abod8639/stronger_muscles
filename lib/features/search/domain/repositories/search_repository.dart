import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Abstract repository defining the contract for search data operations.
/// Follows Clean Architecture by operating strictly on [ProductEntity].
abstract class SearchRepository {
  /// Fetches products from the remote API matching [query].
  Future<List<ProductEntity>> searchProducts(String query);

  /// Filters [products] by price range [min] to [max].
  List<ProductEntity> filterByPrice(
    List<ProductEntity> products,
    double min,
    double max,
  );

  /// Calculates the minimum and maximum price bounds from [products].
  Map<String, double> calculatePriceBounds(List<ProductEntity> products);
}
