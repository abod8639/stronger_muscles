import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_service.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/profile/data/models/localized_string_model.dart';
import 'package:stronger_muscles/features/search/data/repositories/search_repository_impl.dart';

class FakeProductService extends Fake implements ProductService {}

void main() {
  group('SearchRepository Price Filtering & Calculation Tests', () {
    final repository = SearchRepositoryImpl(FakeProductService());

    final p1 = const ProductModel(
      id: '1',
      name: LocalizedString(en: 'Creatine'),
      price: 250.0,
    );
    final p2 = const ProductModel(
      id: '2',
      name: LocalizedString(en: 'BCAA'),
      price: 500.0,
    );
    final p3 = const ProductModel(
      id: '3',
      name: LocalizedString(en: 'Isolate'),
      price: 1500.0,
    );

    final products = [p1, p2, p3];

    test('filterByPrice returns only products within price range', () {
      final filtered = repository.filterByPrice(products, 200.0, 600.0);
      expect(filtered.length, 2);
      expect(filtered.map((p) => p.id), containsAll(['1', '2']));
      expect(filtered.map((p) => p.id), isNot(contains('3')));
    });

    test('calculatePriceBounds calculates min and max correctly', () {
      final bounds = repository.calculatePriceBounds(products);
      expect(bounds['min'], 250.0);
      expect(bounds['max'], 1500.0);
    });

    test('calculatePriceBounds returns fallback values for empty list', () {
      final bounds = repository.calculatePriceBounds([]);
      expect(bounds['min'], 100.0);
      expect(bounds['max'], 10000.0);
    });
  });
}
