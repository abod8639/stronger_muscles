import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/wishlist_service.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class WishlistController extends GetxController {
  // final WishlistService _wishlistService = Get.find<WishlistService>();
  final WishlistService _wishlistService = Get.put(WishlistService());

  // Just a proxy to the service's reactive list
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
