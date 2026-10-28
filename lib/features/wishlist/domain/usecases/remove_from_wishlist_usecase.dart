import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/wishlist/domain/repositories/wishlist_repository.dart';

/// UseCase to remove a product from the wishlist.
class RemoveFromWishlistUseCase {
  final WishlistRepository repository;

  const RemoveFromWishlistUseCase(this.repository);

  Future<Either<Failure, Unit>> call(ProductEntity product) async {
    return repository.removeFromWishlist(product);
  }
}
