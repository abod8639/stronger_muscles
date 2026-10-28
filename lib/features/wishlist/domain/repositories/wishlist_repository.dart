import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';

/// Abstract repository defining the contract for wishlist data operations.
/// Follows Clean Architecture and Functional Error Handling via [Either].
abstract class WishlistRepository {
  /// Fetches wishlist products orchestrating remote and local data sources.
  Future<Either<Failure, List<ProductEntity>>> getWishlistItems();

  /// Reads cached wishlist products synchronously for instant local rendering.
  Either<Failure, List<ProductEntity>> getCachedWishlist();

  /// Adds a product to the wishlist.
  Future<Either<Failure, Unit>> addToWishlist(ProductEntity product);

  /// Removes a product from the wishlist.
  Future<Either<Failure, Unit>> removeFromWishlist(ProductEntity product);

  /// Checks whether a product exists in the wishlist.
  Either<Failure, bool> isInWishlist(String productId);
}
