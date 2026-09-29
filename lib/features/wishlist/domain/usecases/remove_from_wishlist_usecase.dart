import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/wishlist/domain/repositories/wishlist_repository.dart';

class RemoveFromWishlistUseCase {
  final WishlistRepository repository;

  RemoveFromWishlistUseCase(this.repository);

  void call(ProductModel product) {
    if (repository.isInWishlist(product.id)) {
      repository.removeFromWishlist(product);
    }
  }
}
