import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/services/wishlist_service.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';

part 'wishlist_controller.g.dart';

@riverpod
class WishlistController extends _$WishlistController {
  @override
  List<ProductModel> build() {
    return ref.watch(wishlistServiceProvider);
  }

  void addToWishlist(ProductModel product) {
    final wishlistService = ref.read(wishlistServiceProvider.notifier);
    if (!wishlistService.isFavorite(product.id)) {
      wishlistService.toggleFavorite(product);
    }
  }

  void removeFromWishlist(ProductModel product) {
    final wishlistService = ref.read(wishlistServiceProvider.notifier);
    if (wishlistService.isFavorite(product.id)) {
      wishlistService.toggleFavorite(product);
    }
  }

  bool isInWishlist(String productId) {
    return ref.read(wishlistServiceProvider.notifier).isFavorite(productId);
  }
}
