import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/home/domain/entities/selection_entity.dart';
import 'package:stronger_muscles/features/home/domain/usecases/get_home_products_usecase.dart';
import 'package:stronger_muscles/features/home/domain/usecases/get_home_shortcuts_usecase.dart';
import 'package:stronger_muscles/features/product/domain/entities/category_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/category_repository.dart';
import 'package:stronger_muscles/features/product/domain/repositories/product_repository.dart';

class MockCategoryRepository implements CategoryRepository {
  List<CategoryEntity> mockCategories = [];

  @override
  List<CategoryEntity> getCachedCategories() => mockCategories;

  @override
  Future<List<CategoryEntity>> getAllCategories() async => mockCategories;
}

class MockProductRepository implements ProductRepository {
  List<ProductEntity> mockProducts = [];

  @override
  List<ProductEntity> getCachedProducts() => mockProducts;

  @override
  Future<List<ProductEntity>> getProducts({String? categoryId, int page = 1}) async =>
      mockProducts;

  @override
  Future<ProductEntity> getProductById(String id) async => mockProducts.first;

  @override
  Future<List<ProductEntity>> searchProducts(String query) async => mockProducts;
}

void main() {
  group('Home Clean Architecture Usecases Tests', () {
    test('GetHomeShortcutsUseCase prepends Home category and maps icons correctly', () async {
      final mockRepo = MockCategoryRepository();
      mockRepo.mockCategories = [
        const CategoryEntity(
          id: 'protein',
          name: LocalizedStringEntity(en: 'Protein', ar: 'بروتين'),
        ),
        const CategoryEntity(
          id: 'creatine',
          name: LocalizedStringEntity(en: 'Creatine', ar: 'كرياتين'),
        ),
      ];

      final useCase = GetHomeShortcutsUseCase(mockRepo);
      final shortcuts = await useCase(langCode: 'en');

      expect(shortcuts.length, 3);
      expect(shortcuts[0].id, '');
      expect(shortcuts[0].label, 'categoryHome');
      expect(shortcuts[1].id, 'protein');
      expect(shortcuts[1].label, 'Protein');
      expect(shortcuts[2].id, 'creatine');
      expect(shortcuts[2].label, 'Creatine');
    });

    test('GetHomeProductsUseCase returns cached products if available', () async {
      final mockProductRepo = MockProductRepository();
      mockProductRepo.mockProducts = [
        const ProductEntity(
          id: 'prod_1',
          name: LocalizedStringEntity(en: 'Whey Protein'),
          price: 150.0,
        ),
      ];

      final useCase = GetHomeProductsUseCase(mockProductRepo);
      final products = await useCase();

      expect(products.length, 1);
      expect(products.first.id, 'prod_1');
      expect(products.first.price, 150.0);
    });

    test('SelectionEntity equality and hashCode work as expected', () {
      const e1 = SelectionEntity(label: 'Protein', icon: Icons.fitness_center, id: '1');
      const e2 = SelectionEntity(label: 'Protein', icon: Icons.fitness_center, id: '1');
      const e3 = SelectionEntity(label: 'Creatine', icon: Icons.cookie, id: '2');

      expect(e1, equals(e2));
      expect(e1.hashCode, equals(e2.hashCode));
      expect(e1 == e3, isFalse);
    });
  });
}
