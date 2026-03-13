import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';

part 'wishlist_service.g.dart';

@Riverpod(keepAlive: true)
class WishlistService extends _$WishlistService {
  late final Box<String> _box;

  @override
  List<ProductModel> build() {
    _box = Hive.box<String>('wishlist');
    return _loadItems();
  }

  List<ProductModel> _loadItems() {
    return _box.values
        .map((item) {
          try {
            return ProductModel.fromJson(jsonDecode(item));
          } catch (e) {
            return null;
          }
        })
        .whereType<ProductModel>()
        .toList();
  }

  bool isFavorite(String productId) => _box.containsKey(productId);

  void toggleFavorite(ProductModel product) {
    if (_box.containsKey(product.id)) {
      _box.delete(product.id);
      state = state.where((item) => item.id != product.id).toList();
    } else {
      final json = jsonEncode(product.toJson());
      _box.put(product.id, json);
      state = [...state, product];
    }
  }
}
