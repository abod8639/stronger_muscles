import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/wishlist/domain/repositories/wishlist_repository.dart';

class AddToWishlistUseCase {
  final WishlistRepository repository;

  AddToWishlistUseCase(this.repository);

  void call(ProductEntity product) {
    if (!repository.isInWishlist(product.id)) {
      repository.addToWishlist(product);
    }
  }
}
