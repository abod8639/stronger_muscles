import 'package:stronger_muscles/features/wishlist/domain/repositories/wishlist_repository.dart';

class IsInWishlistUseCase {
  final WishlistRepository repository;

  IsInWishlistUseCase(this.repository);

  bool call(String productId) {
    return repository.isInWishlist(productId);
  }
}
