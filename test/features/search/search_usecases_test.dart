import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/search/domain/repositories/search_repository.dart';
import 'package:stronger_muscles/features/search/domain/usecases/calculate_price_bounds_usecase.dart';
import 'package:stronger_muscles/features/search/domain/usecases/filter_by_price_usecase.dart';
import 'package:stronger_muscles/features/search/domain/usecases/search_products_usecase.dart';

class FakeSearchRepository implements SearchRepository {
  final List<ProductEntity> searchResults;

  FakeSearchRepository({this.searchResults = const []});

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    return searchResults;
  }

  @override
  List<ProductEntity> filterByPrice(
    List<ProductEntity> products,
    double min,
    double max,
  ) {
    return products.where((p) => p.price >= min && p.price <= max).toList();
  }

  @override
  Map<String, double> calculatePriceBounds(List<ProductEntity> products) {
    if (products.isEmpty) return {'min': 100, 'max': 10000};
    double minP = products.first.price;
    double maxP = products.first.price;
    for (final p in products) {
      if (p.price < minP) minP = p.price;
      if (p.price > maxP) maxP = p.price;
    }
    return {'min': minP, 'max': maxP};
  }
}

void main() {
  group('Search Domain UseCases Tests', () {
    const p1 = ProductEntity(
      id: '1',
      name: LocalizedStringEntity(en: 'Whey Protein'),
      price: 300.0,
    );
    const p2 = ProductEntity(
      id: '2',
      name: LocalizedStringEntity(en: 'Mass Gainer'),
      price: 600.0,
    );

    test('SearchProductsUseCase delegates to repository.searchProducts',
        () async {
      final repo = FakeSearchRepository(searchResults: [p1, p2]);
      final useCase = SearchProductsUseCase(repo);

      final results = await useCase('protein');
      expect(results.length, 2);
      expect(results.first.id, '1');
    });

    test('FilterByPriceUseCase filters entities accurately', () {
      final repo = FakeSearchRepository();
      final useCase = FilterByPriceUseCase(repo);

      final results = useCase([p1, p2], 250, 400);
      expect(results.length, 1);
      expect(results.first.id, '1');
    });

    test('CalculatePriceBoundsUseCase returns correct min/max bounds', () {
      final repo = FakeSearchRepository();
      final useCase = CalculatePriceBoundsUseCase(repo);

      final bounds = useCase([p1, p2]);
      expect(bounds['min'], 300.0);
      expect(bounds['max'], 600.0);
    });
  });
}
