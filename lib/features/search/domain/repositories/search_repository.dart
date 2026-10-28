import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/search/domain/entities/price_bounds.dart';

/// Pure domain repository defining the contract for search data operations.
/// Operates strictly on domain entities [ProductEntity] and [PriceBounds].
abstract class SearchRepository {
  /// Fetches products matching [query] wrapped in functional [Either].
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);

  /// Filters [products] by price range [min] to [max].
  List<ProductEntity> filterByPrice(
    List<ProductEntity> products,
    double min,
    double max,
  );

  /// Calculates the minimum and maximum price bounds from [products].
  PriceBounds calculatePriceBounds(List<ProductEntity> products);

  /// Retrieves search history items from local persistence.
  Either<Failure, List<String>> getSearchHistory();

  /// Adds a search query to search history and returns updated list.
  Future<Either<Failure, List<String>>> addSearchTerm(String term);

  /// Removes a search query from search history and returns updated list.
  Future<Either<Failure, List<String>>> removeSearchTerm(String term);

  /// Clears all items in the search history.
  Future<Either<Failure, Unit>> clearSearchHistory();
}
