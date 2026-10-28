import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';

/// Local data source for caching products using Hive with in-memory fallback.
class ProductLocalDataSource {
  static const String boxName = 'products';
  Box<ProductModel>? _box;
  final Map<String, ProductModel> _inMemoryFallback = {};
  bool _hiveFailed = false;

  ProductLocalDataSource([this._box]);

  Box<ProductModel>? _getBoxSafe() {
    if (_box != null && _box!.isOpen) return _box;
    if (_hiveFailed) return null;
    try {
      if (Hive.isBoxOpen(boxName)) {
        _box = Hive.box<ProductModel>(boxName);
        return _box;
      }
      return null;
    } catch (e) {
      _hiveFailed = true;
      debugPrint('[ProductLocalDataSource] Hive fallback active: $e');
      return null;
    }
  }

  List<ProductModel> getCachedProducts() {
    try {
      final box = _getBoxSafe();
      if (box != null && box.isOpen) {
        return box.values.toList();
      }
      return _inMemoryFallback.values.toList();
    } catch (e) {
      debugPrint('[ProductLocalDataSource] Error getting cached products: $e');
      return _inMemoryFallback.values.toList();
    }
  }

  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final box = _getBoxSafe();
      if (box != null && box.isOpen) {
        for (final product in products) {
          await box.put(product.id, product);
        }
      }
      for (final product in products) {
        _inMemoryFallback[product.id] = product;
      }
    } catch (e) {
      debugPrint('[ProductLocalDataSource] Error caching products: $e');
      for (final product in products) {
        _inMemoryFallback[product.id] = product;
      }
    }
  }

  Future<void> cacheProduct(ProductModel product) async {
    try {
      final box = _getBoxSafe();
      if (box != null && box.isOpen) {
        await box.put(product.id, product);
      }
      _inMemoryFallback[product.id] = product;
    } catch (e) {
      debugPrint('[ProductLocalDataSource] Error caching single product: $e');
      _inMemoryFallback[product.id] = product;
    }
  }

  ProductModel? getProductById(String id) {
    try {
      final box = _getBoxSafe();
      if (box != null && box.isOpen) {
        return box.get(id) ?? _inMemoryFallback[id];
      }
      return _inMemoryFallback[id];
    } catch (e) {
      return _inMemoryFallback[id];
    }
  }

  Future<void> clearCache() async {
    try {
      final box = _getBoxSafe();
      if (box != null && box.isOpen) {
        await box.clear();
      }
      _inMemoryFallback.clear();
    } catch (e) {
      _inMemoryFallback.clear();
    }
  }
}
