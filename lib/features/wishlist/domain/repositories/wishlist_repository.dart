import 'package:stronger_muscles/features/product/data/models/product_model.dart';

/// Abstract repository defining the contract for wishlist data operations.
abstract class WishlistRepository {
  /// Returns the list of all products currently in the wishlist.
  List<ProductModel> getWishlistItems();

  /// Adds a product to the wishlist.
  void addToWishlist(ProductModel product);

  /// Removes a product from the wishlist.
  void removeFromWishlist(ProductModel product);

  /// Checks whether a product is in the wishlist.
  bool isInWishlist(String productId);
}
