import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/domain/entities/category_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/category_repository.dart';
import 'package:stronger_muscles/features/product/domain/repositories/product_repository.dart';
import 'package:stronger_muscles/features/product/domain/usecases/get_all_categories_usecase.dart';
import 'package:stronger_muscles/features/product/domain/usecases/get_cached_categories_usecase.dart';
import 'package:stronger_muscles/features/product/domain/usecases/get_cached_products_usecase.dart';
import 'package:stronger_muscles/features/product/domain/usecases/get_product_by_id_usecase.dart';
import 'package:stronger_muscles/features/product/domain/usecases/get_products_usecase.dart';
import 'package:stronger_muscles/features/product/domain/usecases/search_products_usecase.dart';

class MockProductRepository implements ProductRepository {
  final List<ProductEntity> products = [];

  @override
  List<ProductEntity> getCachedProducts() => products;

  @override
  Future<List<ProductEntity>> getProducts({String? categoryId, int page = 1}) async {
    if (categoryId != null) {
      return products.where((p) => p.categoryId == categoryId).toList();
    }
    return products;
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    return products.firstWhere((p) => p.id == id);
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    return products
        .where((p) => p.getLocalizedName().toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

class MockCategoryRepository implements CategoryRepository {
  final List<CategoryEntity> categories = [];

  @override
  List<CategoryEntity> getCachedCategories() => categories;

  @override
  Future<List<CategoryEntity>> getAllCategories() async => categories;
}

void main() {
  group('Product Use Cases Tests', () {
    late MockProductRepository mockProductRepository;
    late MockCategoryRepository mockCategoryRepository;

    const sampleProduct = ProductEntity(
      id: 'prod-1',
      name: LocalizedStringEntity(ar: 'بروتين مصل اللبن', en: 'Whey Protein'),
      price: 100.0,
      discountPrice: 80.0,
      stockQuantity: 10,
    );

    const sampleCategory = CategoryEntity(
      id: 'cat-1',
      name: LocalizedStringEntity(ar: 'بروتين', en: 'Protein'),
    );

    setUp(() {
      mockProductRepository = MockProductRepository();
      mockCategoryRepository = MockCategoryRepository();
      mockProductRepository.products.add(sampleProduct);
      mockCategoryRepository.categories.add(sampleCategory);
    });

    test('GetProductsUseCase returns products', () async {
      final useCase = GetProductsUseCase(mockProductRepository);
      final result = await useCase();

      expect(result.length, 1);
      expect(result.first.id, 'prod-1');
      expect(result.first.hasDiscount, isTrue);
      expect(result.first.discountPercentage, 20.0);
    });

    test('GetCachedProductsUseCase returns synchronous cached products', () {
      final useCase = GetCachedProductsUseCase(mockProductRepository);
      final result = useCase();

      expect(result.length, 1);
      expect(result.first.getLocalizedName(locale: 'en'), 'Whey Protein');
    });

    test('GetProductByIdUseCase returns single product by id', () async {
      final useCase = GetProductByIdUseCase(mockProductRepository);
      final result = await useCase('prod-1');

      expect(result.id, 'prod-1');
      expect(result.isInStock, isTrue);
    });

    test('SearchProductsUseCase filters products by name', () async {
      final useCase = SearchProductsUseCase(mockProductRepository);
      final result = await useCase('Whey');

      expect(result.length, 1);
      expect(result.first.id, 'prod-1');

      final emptyResult = await useCase('Creatine');
      expect(emptyResult, isEmpty);
    });

    test('GetAllCategoriesUseCase returns categories', () async {
      final useCase = GetAllCategoriesUseCase(mockCategoryRepository);
      final result = await useCase();

      expect(result.length, 1);
      expect(result.first.id, 'cat-1');
      expect(result.first.getLocalizedName(locale: 'ar'), 'بروتين');
    });

    test('GetCachedCategoriesUseCase returns synchronous cached categories', () {
      final useCase = GetCachedCategoriesUseCase(mockCategoryRepository);
      final result = useCase();

      expect(result.length, 1);
      expect(result.first.id, 'cat-1');
    });

    test('ProductModel toEntity and fromEntity round-trip conversion preserves fields', () {
      final model = ProductModel.fromEntity(sampleProduct);
      expect(model.id, sampleProduct.id);
      expect(model.price, sampleProduct.price);
      expect(model.discountPrice, sampleProduct.discountPrice);

      final entity = model.toEntity();
      expect(entity.id, sampleProduct.id);
      expect(entity.price, sampleProduct.price);
      expect(entity.discountPrice, sampleProduct.discountPrice);
      expect(entity.getLocalizedName(locale: 'en'), 'Whey Protein');
    });
  });
}
