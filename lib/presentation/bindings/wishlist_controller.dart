import 'dart:developer' as developer;
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/data/repositories/product_repository.dart';

class WishlistController extends GetxController {
  final RxList<ProductModel> wishlistItems = <ProductModel>[].obs;
  late Box<String> wishlistBox;
  final ProductRepository _productRepository = ProductRepository();

  @override
  void onInit() {
    super.onInit();
    wishlistBox = Hive.box<String>('wishlist');
  }

  @override
  void onReady() {
    super.onReady();
    _loadWishlistItems();
  }

  Future<void> _loadWishlistItems() async {
    wishlistItems.clear();
    for (var productId in wishlistBox.keys) {
      final product = await _productRepository.getProductById(productId);
      if (product != null) {
        wishlistItems.add(product);
      } else {
        // Optionally, handle cases where a product in the wishlist is no longer available
        developer.log(
          'Warning: Product with ID $productId not found.',
          name: 'WishlistController',
          level: 900, // WARNING
        );
      }
    }
  }

  void addToWishlist(ProductModel product) {
    if (!wishlistBox.containsKey(product.id)) {
      wishlistBox.put(product.id, product.id);
      wishlistItems.add(product);
    }
  }

  void removeFromWishlist(ProductModel product) {
    wishlistBox.delete(product.id);
    wishlistItems.removeWhere((item) => item.id == product.id);
  }
}
