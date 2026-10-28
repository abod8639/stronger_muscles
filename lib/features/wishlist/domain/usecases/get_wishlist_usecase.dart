import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/wishlist/domain/repositories/wishlist_repository.dart';

/// UseCase to retrieve wishlist products with functional error handling.
class GetWishlistUseCase {
  final WishlistRepository repository;

  const GetWishlistUseCase(this.repository);

  /// Asynchronously fetches fresh wishlist items (Remote with Local fallback).
  Future<Either<Failure, List<ProductEntity>>> call() {
    return repository.getWishlistItems();
  }

  /// Synchronously fetches local cached wishlist items for zero-latency UI rendering.
  Either<Failure, List<ProductEntity>> getCached() {
    return repository.getCachedWishlist();
  }
}
