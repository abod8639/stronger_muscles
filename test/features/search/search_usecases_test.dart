import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/product_feature.dart'
    hide SearchProductsUseCase;
import 'package:stronger_muscles/features/search/domain/entities/price_bounds.dart';
import 'package:stronger_muscles/features/search/domain/repositories/search_repository.dart';
import 'package:stronger_muscles/features/search/domain/usecases/calculate_price_bounds_usecase.dart';
import 'package:stronger_muscles/features/search/domain/usecases/filter_by_price_usecase.dart';
import 'package:stronger_muscles/features/search/domain/usecases/search_products_usecase.dart';

class FakeSearchRepository implements SearchRepository {
  final List<ProductEntity> searchResults;
  final List<String> history = [];

  FakeSearchRepository({this.searchResults = const []});

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query) async {
    return Right(searchResults);
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
  PriceBounds calculatePriceBounds(List<ProductEntity> products) {
    if (products.isEmpty) {
      return const PriceBounds(min: 0.0, max: 0.0);
    }
    double min = products.first.price;
    double max = products.first.price;
    for (final p in products) {
      if (p.price < min) min = p.price;
      if (p.price > max) max = p.price;
    }
    return PriceBounds(min: min, max: max);
  }

  @override
  Either<Failure, List<String>> getSearchHistory() => Right(List.unmodifiable(history));

  @override
  Future<Either<Failure, List<String>>> addSearchTerm(String term) async {
    if (!history.contains(term)) {
      history.insert(0, term);
    }
    return Right(List.unmodifiable(history));
  }

  @override
  Future<Either<Failure, List<String>>> removeSearchTerm(String term) async {
    history.remove(term);
    return Right(List.unmodifiable(history));
  }

  @override
  Future<Either<Failure, Unit>> clearSearchHistory() async {
    history.clear();
    return const Right(unit);
  }
}

void main() {
  group('Search UseCases Tests', () {
    const p1 = ProductEntity(
      id: '1',
      name: LocalizedStringEntity(en: 'Creatine'),
      price: 300.0,
    );
    const p2 = ProductEntity(
      id: '2',
      name: LocalizedStringEntity(en: 'Whey Protein'),
      price: 600.0,
    );

    test('SearchProductsUseCase delegates to repository.searchProducts', () async {
      final repo = FakeSearchRepository(searchResults: [p1, p2]);
      final useCase = SearchProductsUseCase(repo);

      final result = await useCase('protein');

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Expected Right but got Left'),
        (products) => expect(products, [p1, p2]),
      );
    });

    test('FilterByPriceUseCase filters products by range correctly', () {
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
      expect(bounds.min, 300.0);
      expect(bounds.max, 600.0);
      expect(bounds['min'], 300.0);
      expect(bounds['max'], 600.0);
    });

    test('CalculatePriceBoundsUseCase returns 0 bounds for empty list', () {
      final repo = FakeSearchRepository();
      final useCase = CalculatePriceBoundsUseCase(repo);

      final bounds = useCase([]);
      expect(bounds.min, 0.0);
      expect(bounds.max, 0.0);
    });
  });
}
