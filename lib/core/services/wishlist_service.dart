import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class WishlistService extends GetxService {
  final RxList<ProductModel> items = <ProductModel>[].obs;
  late Box<String> _box;

  Future<WishlistService> init() async {
    _box = await Hive.openBox<String>('wishlist');
    _loadItems();
    return this;
  }

  void _loadItems() {
    items.assignAll(_box.values.map((item) {
      try {
        return ProductModel.fromJson(jsonDecode(item));
      } catch (e) {
        // Fallback or handle error
        return null;
      }
    }).whereType<ProductModel>().toList());
  }

  bool isFavorite(String productId) => _box.containsKey(productId);

  void toggleFavorite(ProductModel product) {
    if (_box.containsKey(product.id)) {
      _box.delete(product.id);
      items.removeWhere((item) => item.id == product.id);
    } else {
      final json = jsonEncode(product.toJson());
      _box.put(product.id, json);
      items.add(product);
    }
  }

  List<ProductModel> getWishlistItems() => items.toList();
}
}
