import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/product_service.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class ProductRepository {
  final ProductService _service = Get.find<ProductService>();
  final Box<ProductModel> _box = Hive.box<ProductModel>('products');

  /// Get cached products
  List<ProductModel> getCachedProducts() => _box.values.toList();

  /// Fetch and cache products
  Future<List<ProductModel>> getProducts({String? categoryId}) async {
    try {
      final products = await _service.getProducts(categoryId: categoryId);

      // We only cache the "main" product list (no category filter) or all of them.
      // Usually better to cache the latest results or specific categories.
      // For simplicity, we can cache all items by their ID.
      for (var product in products) {
        await _box.put(product.id, product);
      }

      return products;
    } on Failure catch (e) {
      if (e.type == FailureType.network && _box.isNotEmpty) {
        return _box.values.toList();
      }
      rethrow;
    }
  }

  Future<ProductModel> getProductDetails(String id) async {
    try {
      final product = await _service.getProductDetails(id);
      await _box.put(product.id, product);
      return product;
    } on Failure catch (_) {
      if (_box.containsKey(id)) {
        return _box.get(id)!;
      }
      rethrow;
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      return await _service.getProducts(categoryId: categoryId);
    } on Failure catch (e) {
      if (e.type == FailureType.network) {
        return _box.values.where((p) => p.categoryId == categoryId).toList();
      }
      rethrow;
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      return await _service.getProducts(query: query);
    } on Failure catch (e) {
      if (e.type == FailureType.network) {
        return _box.values
            .where((p) => p.getLocalizedName(locale: 'en').toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      rethrow;
    }
  }
}
