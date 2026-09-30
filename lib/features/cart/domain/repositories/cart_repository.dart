import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Domain contract defining cart operations.
abstract class CartRepository {
  Future<List<CartItemEntity>> getCartItems();
  Future<void> addToCart(
    ProductEntity product, {
    String? selectedFlavor,
    String? selectedSize,
    int quantity = 1,
  });
  Future<void> removeFromCart(String itemId);
  Future<void> updateQuantity(String itemId, int quantity);
  Future<void> clearCart();
}
