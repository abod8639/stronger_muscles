import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/wishlist/domain/repositories/wishlist_repository.dart';

class RemoveFromWishlistUseCase {
  final WishlistRepository repository;

  RemoveFromWishlistUseCase(this.repository);

  void call(ProductEntity product) {
    if (repository.isInWishlist(product.id)) {
      repository.removeFromWishlist(product);
    }
  }
}
