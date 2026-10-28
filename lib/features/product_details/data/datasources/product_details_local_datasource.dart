import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';

/// Local data source for caching product details and reviews using Hive with in-memory fallback.
class ProductDetailsLocalDataSource {
  static const String productBoxName = 'products';
  static const String reviewsBoxName = 'product_reviews';

  Box<ProductModel>? _productBox;
  Box<List>? _reviewsBox;

  final Map<String, ProductModel> _productInMemoryFallback = {};
  final Map<String, List<ReviewModel>> _reviewsInMemoryFallback = {};
  bool _hiveFailed = false;

  ProductDetailsLocalDataSource([this._productBox, this._reviewsBox]);

  Box<ProductModel>? _getProductBoxSafe() {
    if (_productBox != null && _productBox!.isOpen) return _productBox;
    if (_hiveFailed) return null;
    try {
      if (Hive.isBoxOpen(productBoxName)) {
        _productBox = Hive.box<ProductModel>(productBoxName);
        return _productBox;
      }
      return null;
    } catch (e) {
      _hiveFailed = true;
      debugPrint('[ProductDetailsLocalDataSource] Hive fallback active: $e');
      return null;
    }
  }

  /// Get cached product by id.
  ProductModel? getCachedProduct(String id) {
    try {
      final box = _getProductBoxSafe();
      if (box != null && box.isOpen) {
        return box.get(id);
      }
      return _productInMemoryFallback[id];
    } catch (e) {
      debugPrint('[ProductDetailsLocalDataSource] Error getting cached product: $e');
      return _productInMemoryFallback[id];
    }
  }

  /// Save product to cache.
  Future<void> cacheProduct(ProductModel product) async {
    try {
      final box = _getProductBoxSafe();
      if (box != null && box.isOpen) {
        await box.put(product.id, product);
      }
      _productInMemoryFallback[product.id] = product;
    } catch (e) {
      debugPrint('[ProductDetailsLocalDataSource] Error caching product: $e');
      _productInMemoryFallback[product.id] = product;
    }
  }

  /// Get cached reviews for a product.
  List<ReviewModel>? getCachedReviews(String productId) {
    try {
      if (_reviewsBox != null && _reviewsBox!.isOpen) {
        final list = _reviewsBox!.get(productId);
        if (list != null) {
          return list.whereType<ReviewModel>().toList();
        }
      }
      return _reviewsInMemoryFallback[productId];
    } catch (e) {
      debugPrint('[ProductDetailsLocalDataSource] Error getting cached reviews: $e');
      return _reviewsInMemoryFallback[productId];
    }
  }

  /// Cache reviews for a product.
  Future<void> cacheReviews(String productId, List<ReviewModel> reviews) async {
    try {
      if (_reviewsBox != null && _reviewsBox!.isOpen) {
        await _reviewsBox!.put(productId, reviews);
      }
      _reviewsInMemoryFallback[productId] = reviews;
    } catch (e) {
      debugPrint('[ProductDetailsLocalDataSource] Error caching reviews: $e');
      _reviewsInMemoryFallback[productId] = reviews;
    }
  }
}
