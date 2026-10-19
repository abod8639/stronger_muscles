import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_service.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/profile/data/models/localized_string_model.dart';
import 'package:stronger_muscles/features/search/data/repositories/search_repository_impl.dart';

class FakeProductService extends Fake implements ProductService {
  final List<ProductModel> modelsToReturn;

  FakeProductService({this.modelsToReturn = const []});

  @override
  Future<List<ProductModel>> getProducts({
    String? categoryId,
    String? brand,
    String? query,
    int page = 1,
    int limit = 20,
    bool? featured,
    bool? newArrival,
    bool? bestSeller,
  }) async {
    return modelsToReturn;
  }
}

void main() {
  group('SearchRepository Price Filtering & Calculation Tests', () {
    final repository = SearchRepositoryImpl(FakeProductService());

    const p1 = ProductEntity(
      id: '1',
      name: LocalizedStringEntity(en: 'Creatine'),
      price: 250.0,
    );
    const p2 = ProductEntity(
      id: '2',
      name: LocalizedStringEntity(en: 'BCAA'),
      price: 500.0,
    );
    const p3 = ProductEntity(
      id: '3',
      name: LocalizedStringEntity(en: 'Isolate'),
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

    test('searchProducts converts models from service into ProductEntity', () async {
      final sampleModels = [
        const ProductModel(
          id: '10',
          name: LocalizedString(en: 'Whey Protein'),
          price: 900.0,
        ),
      ];
      final repoWithService =
          SearchRepositoryImpl(FakeProductService(modelsToReturn: sampleModels));

      final results = await repoWithService.searchProducts('whey');

      expect(results.length, 1);
      expect(results.first, isA<ProductEntity>());
      expect(results.first.id, '10');
      expect(results.first.price, 900.0);
    });
  });
}
