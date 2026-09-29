import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/wishlist/domain/repositories/wishlist_repository.dart';

class AddToWishlistUseCase {
  final WishlistRepository repository;

  AddToWishlistUseCase(this.repository);

  void call(ProductModel product) {
    if (!repository.isInWishlist(product.id)) {
      repository.addToWishlist(product);
    }
  }
}
