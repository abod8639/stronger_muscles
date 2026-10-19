import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Abstract repository defining the contract for wishlist data operations.
/// Follows Clean Architecture by operating on pure domain [ProductEntity].
abstract class WishlistRepository {
  /// Returns the list of all products currently in the wishlist.
  List<ProductEntity> getWishlistItems();

  /// Adds a product to the wishlist.
  void addToWishlist(ProductEntity product);

  /// Removes a product from the wishlist.
  void removeFromWishlist(ProductEntity product);

  /// Checks whether a product is in the wishlist.
  bool isInWishlist(String productId);
}
