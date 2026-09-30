import 'dart:math' as math;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_service.dart';
import 'package:stronger_muscles/features/search/domain/repositories/search_repository.dart';

part 'search_repository_impl.g.dart';

@riverpod
SearchRepository searchRepository(SearchRepositoryRef ref) {
  return SearchRepositoryImpl(ref.watch(productServiceProvider));
}

/// Concrete implementation of [SearchRepository].
///
/// Combines remote API calls and local price-filtering logic.
class SearchRepositoryImpl implements SearchRepository {
  final ProductService _productService;

  SearchRepositoryImpl(this._productService);

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    return await _productService.getProducts(query: query);
  }

  @override
  List<ProductModel> filterByPrice(
    List<ProductModel> products,
    double min,
    double max,
  ) {
    return products.where((p) => p.price >= min && p.price <= max).toList();
  }

  @override
  Map<String, double> calculatePriceBounds(List<ProductModel> products) {
    if (products.isEmpty) {
      return {'min': 100, 'max': 10000};
    }
    double minPrice = products.first.price;
    double maxPrice = products.first.price;
    for (var p in products) {
      minPrice = math.min(minPrice, p.price);
      maxPrice = math.max(maxPrice, p.price);
    }
    return {'min': minPrice, 'max': maxPrice};
  }
}
