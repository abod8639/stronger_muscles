import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/wishlist_service.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class WishlistController extends GetxController {
  WishlistService get _wishlistService => Get.find<WishlistService>();

  RxList<ProductModel> get wishlistItems => _wishlistService.items;

  void addToWishlist(ProductModel product) {
    if (!_wishlistService.isFavorite(product.id)) {
      _wishlistService.toggleFavorite(product);
    }
  }

  void removeFromWishlist(ProductModel product) {
    if (_wishlistService.isFavorite(product.id)) {
      _wishlistService.toggleFavorite(product);
    }
  }

  bool isInWishlist(String productId) {
    return _wishlistService.isFavorite(productId);
  }
}
