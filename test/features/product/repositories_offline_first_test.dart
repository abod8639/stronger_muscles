import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_local_datasource.dart';
import 'package:stronger_muscles/features/product/data/models/category_model.dart';
import 'package:stronger_muscles/features/profile/data/models/localized_string_model.dart';

void main() {
  late Directory tempDir;
  late CategoryLocalDataSource localDataSource;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_category_');
    Hive.init(tempDir.path);

    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(LocalizedStringAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(CategoryModelAdapter());
    }
  });

  setUp(() async {
    if (!Hive.isBoxOpen('categories')) {
      await Hive.openBox<CategoryModel>('categories');
    } else {
      await Hive.box<CategoryModel>('categories').clear();
    }
    localDataSource = CategoryLocalDataSource();
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('CategoryLocalDataSource Offline Cache Tests', () {
    test('cacheCategories stores and getCachedCategories retrieves list', () async {
      const sampleCategories = [
        CategoryModel(
          id: 'cat-prot',
          name: LocalizedString(ar: 'بروتين', en: 'Protein'),
          sortOrder: 1,
        ),
        CategoryModel(
          id: 'cat-vit',
          name: LocalizedString(ar: 'فيتامينات', en: 'Vitamins'),
          sortOrder: 2,
        ),
      ];

      expect(localDataSource.getCachedCategories(), isEmpty);

      await localDataSource.cacheCategories(sampleCategories);

      final cached = localDataSource.getCachedCategories();
      expect(cached.length, 2);
      expect(cached.first.id, 'cat-prot');
      expect(cached.first.getLocalizedName(locale: 'ar'), 'بروتين');
      expect(cached.last.id, 'cat-vit');
    });

    test('cacheCategories clears previous items when updating cache', () async {
      const initial = [
        CategoryModel(id: 'old-1', name: LocalizedString(en: 'Old')),
      ];
      await localDataSource.cacheCategories(initial);
      expect(localDataSource.getCachedCategories().length, 1);

      const updated = [
        CategoryModel(id: 'new-1', name: LocalizedString(en: 'New')),
      ];
      await localDataSource.cacheCategories(updated);

      final result = localDataSource.getCachedCategories();
      expect(result.length, 1);
      expect(result.first.id, 'new-1');
    });
  });
}
