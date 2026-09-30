import 'package:stronger_muscles/features/product/data/models/product_model.dart';

/// Abstract repository defining the contract for search data operations.
abstract class SearchRepository {
  /// Fetches products from the remote API matching [query].
  Future<List<ProductModel>> searchProducts(String query);

  /// Filters [products] by price range [min] to [max].
  List<ProductModel> filterByPrice(
    List<ProductModel> products,
    double min,
    double max,
  );

  /// Calculates the minimum and maximum price bounds from [products].
  Map<String, double> calculatePriceBounds(List<ProductModel> products);
}
