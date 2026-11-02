import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/home/data/datasources/home_local_data_source.dart';
import 'package:stronger_muscles/features/home/data/datasources/home_remote_datasource.dart';
import 'package:stronger_muscles/features/home/data/models/selection_model.dart';
import 'package:stronger_muscles/features/home/data/repositories/home_repository_impl.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_local_datasource.dart';
import 'package:stronger_muscles/features/product/data/models/image_url_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_category_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_size_model.dart';
import 'package:stronger_muscles/features/profile/data/models/localized_string_model.dart';

class FakeHomeRemoteDataSource implements HomeRemoteDataSource {
  Object? errorToThrow;
  List<ProductModel> mockProducts = [];

  @override
  Future<List<SelectionsModel>> getCategories({
    CancelToken? cancelToken,
  }) async {
    return [];
  }

  @override
  Future<List<ProductModel>> getProducts({
    String? categoryId,
    int page = 1,
    int limit = 20,
    CancelToken? cancelToken,
  }) async {
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
    return mockProducts;
  }
}

void main() {
  late Directory tempDir;
  late FakeHomeRemoteDataSource fakeRemoteDataSource;
  late ProductLocalDataSource productLocalDataSource;
  late HomeLocalDataSourceImpl homeLocalDataSource;
  late HomeRepositoryImpl homeRepository;

  const testProduct = ProductModel(
    id: 'prod-1',
    name: LocalizedString(ar: 'واي بروتين', en: 'Whey Protein'),
    brand: 'Optimum',
    price: 60.0,
    category: ProductCategory(
      id: 'cat-protein',
      name: LocalizedString(ar: 'بروتين', en: 'Protein'),
    ),
  );

  const testProduct2 = ProductModel(
    id: 'prod-2',
    name: LocalizedString(ar: 'كرياتين', en: 'Creatine'),
    brand: 'Optimum',
    price: 35.0,
    category: ProductCategory(
      id: 'cat-creatine',
      name: LocalizedString(ar: 'كرياتين', en: 'Creatine'),
    ),
  );

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_test_home_offline_');
    Hive.init(tempDir.path);

    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(LocalizedStringAdapter());
    }
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(ImageUrlAdapter());
    }
    if (!Hive.isAdapterRegistered(13)) {
      Hive.registerAdapter(ProductCategoryAdapter());
    }
    if (!Hive.isAdapterRegistered(14)) {
      Hive.registerAdapter(ProductSizeAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(ProductModelAdapter());
    }
  });

  setUp(() async {
    if (!Hive.isBoxOpen(ProductLocalDataSource.boxName)) {
      await Hive.openBox<ProductModel>(ProductLocalDataSource.boxName);
    } else {
      await Hive.box<ProductModel>(ProductLocalDataSource.boxName).clear();
    }

    fakeRemoteDataSource = FakeHomeRemoteDataSource();
    productLocalDataSource = ProductLocalDataSource();
    homeLocalDataSource = HomeLocalDataSourceImpl(null, productLocalDataSource);
    homeRepository = HomeRepositoryImpl(
      fakeRemoteDataSource,
      homeLocalDataSource,
    );
  });

  tearDownAll(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Home Offline-First & Cache Tests', () {
    test(
      'homeLocalDataSource caches and retrieves products via ProductLocalDataSource',
      () async {
        await homeLocalDataSource.cacheProducts([testProduct, testProduct2]);

        final allCached = await homeLocalDataSource.getCachedProducts();
        expect(allCached.length, 2);
        expect(allCached.any((p) => p.id == 'prod-1'), isTrue);
        expect(allCached.any((p) => p.id == 'prod-2'), isTrue);

        final proteinOnly = await homeLocalDataSource.getCachedProducts(
          categoryId: 'cat-protein',
        );
        expect(proteinOnly.length, 1);
        expect(proteinOnly.first.id, 'prod-1');
      },
    );

    test(
      'getHomeProducts returns cached products when remote data source fails with NetworkFailure',
      () async {
        await homeLocalDataSource.cacheProducts([testProduct, testProduct2]);

        fakeRemoteDataSource.errorToThrow = const NetworkFailure();

        final result = await homeRepository.getHomeProducts(page: 1);

        expect(result.isRight(), isTrue);
        result.fold(
          (failure) =>
              fail('Expected cached products, but got failure: $failure'),
          (products) {
            expect(products.length, 2);
            expect(products.first.id, 'prod-1');
            expect(products.first.name?.ar, 'واي بروتين');
          },
        );
      },
    );

    test(
      'getHomeProducts returns category-specific cached products when offline',
      () async {
        await homeLocalDataSource.cacheProducts([testProduct, testProduct2]);

        fakeRemoteDataSource.errorToThrow = const NetworkFailure();

        final result = await homeRepository.getHomeProducts(
          categoryId: 'cat-protein',
          page: 1,
        );

        expect(result.isRight(), isTrue);
        result.fold(
          (failure) =>
              fail('Expected cached products for protein, but got: $failure'),
          (products) {
            expect(products.length, 1);
            expect(products.first.id, 'prod-1');
          },
        );
      },
    );
  });
}
