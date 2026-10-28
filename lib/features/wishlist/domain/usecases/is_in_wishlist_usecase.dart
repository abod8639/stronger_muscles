import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/wishlist/domain/repositories/wishlist_repository.dart';

/// UseCase to check if a product is in the wishlist.
class IsInWishlistUseCase {
  final WishlistRepository repository;

  const IsInWishlistUseCase(this.repository);

  Either<Failure, bool> call(String productId) {
    return repository.isInWishlist(productId);
  }
}
