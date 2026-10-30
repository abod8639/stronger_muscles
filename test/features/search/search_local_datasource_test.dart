import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/profile/data/models/localized_string_model.dart';
import 'package:stronger_muscles/features/search/data/datasources/search_local_datasource.dart';

void main() {
  group('SearchLocalDataSourceImpl Tests', () {
    late SearchLocalDataSourceImpl dataSource;

    setUp(() {
      dataSource = SearchLocalDataSourceImpl();
    });

    test('addSearchTerm adds query and returns newest first', () async {
      await dataSource.addSearchTerm('Creatine');
      final history = await dataSource.addSearchTerm('Protein');

      expect(history, ['Protein', 'Creatine']);
    });

    test('addSearchTerm prevents duplicates case-insensitively', () async {
      await dataSource.addSearchTerm('creatine');
      final history = await dataSource.addSearchTerm('Creatine');

      expect(history, ['Creatine']);
    });

    test('removeSearchTerm removes term from history', () async {
      await dataSource.addSearchTerm('Creatine');
      await dataSource.addSearchTerm('Protein');

      final updated = await dataSource.removeSearchTerm('Creatine');
      expect(updated, ['Protein']);
    });

    test('clearSearchHistory empties all search terms', () async {
      await dataSource.addSearchTerm('Creatine');
      await dataSource.addSearchTerm('Protein');

      await dataSource.clearSearchHistory();
      expect(dataSource.getSearchHistory(), isEmpty);
    });

    test('cacheSearchResults stores and retrieves products by query', () async {
      const sampleModels = [
        ProductModel(
          id: 'prod_1',
          name: LocalizedString(en: 'Whey Protein'),
          price: 500.0,
        ),
      ];

      await dataSource.cacheSearchResults('whey', sampleModels);
      final cached = dataSource.getCachedSearchResults('whey');

      expect(cached.length, 1);
      expect(cached.first.id, 'prod_1');
    });
  });
}
