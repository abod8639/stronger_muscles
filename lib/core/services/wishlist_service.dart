import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class WishlistService extends GetxService {
  late Box<String> _box;

  Future<WishlistService> init() async {
    _box = await Hive.openBox<String>('wishlist');
    return this;
  }

  bool isFavorite(String productId) => _box.containsKey(productId);

  void toggleFavorite(ProductModel product) {
    if (_box.containsKey(product.id)) {
      _box.delete(product.id);
    } else {
      _box.put(product.id, jsonEncode(product.toJson()));
    }
  }

  List<ProductModel> getWishlistItems() {
    return _box.values
        .map((item) => ProductModel.fromJson(jsonDecode(item)))
        .toList();
  }
}
