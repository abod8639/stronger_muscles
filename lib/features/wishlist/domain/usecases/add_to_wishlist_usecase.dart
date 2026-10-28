import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/wishlist/domain/repositories/wishlist_repository.dart';

/// UseCase to add a product to the wishlist with duplicate prevention.
class AddToWishlistUseCase {
  final WishlistRepository repository;

  const AddToWishlistUseCase(this.repository);

  Future<Either<Failure, Unit>> call(ProductEntity product) async {
    final checkResult = repository.isInWishlist(product.id);
    return checkResult.fold(
      (failure) => repository.addToWishlist(product),
      (isInWishlist) {
        if (!isInWishlist) {
          return repository.addToWishlist(product);
        }
        return const Right(unit);
      },
    );
  }
}
