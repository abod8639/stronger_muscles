import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/profile/data/models/localized_string_model.dart';
import 'package:stronger_muscles/features/search/data/datasources/search_local_datasource.dart';

void main() {
  group('SearchLocalDataSource Tests', () {
    final dataSource = SearchLocalDataSource();

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
      final filtered = dataSource.filterByPrice(products, 200.0, 600.0);
      expect(filtered.length, 2);
      expect(filtered.map((p) => p.id), containsAll(['1', '2']));
      expect(filtered.map((p) => p.id), isNot(contains('3')));
    });

    test('calculatePriceBounds calculates min and max correctly', () {
      final bounds = dataSource.calculatePriceBounds(products);
      expect(bounds['min'], 250.0);
      expect(bounds['max'], 1500.0);
    });

    test('calculatePriceBounds returns fallback values for empty list', () {
      final bounds = dataSource.calculatePriceBounds([]);
      expect(bounds['min'], 100.0);
      expect(bounds['max'], 10000.0);
    });
  });
}
