import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';

/// Local datasource for wishlist, backed by Hive.
class WishlistLocalDatasource {
  final Box<String> _box;

  WishlistLocalDatasource(this._box);

  /// Loads all wishlist items from local storage.
  List<ProductModel> getAll() {
    return _box.values
        .map((item) {
          try {
            return ProductModel.fromJson(jsonDecode(item));
          } catch (_) {
            return null;
          }
        })
        .whereType<ProductModel>()
        .toList();
  }

  /// Checks whether a product exists in the wishlist.
  bool contains(String productId) => _box.containsKey(productId);

  /// Adds a product to local storage.
  void add(ProductModel product) {
    final json = jsonEncode(product.toJson());
    _box.put(product.id, json);
  }

  /// Removes a product from local storage.
  void remove(String productId) {
    _box.delete(productId);
  }
}
