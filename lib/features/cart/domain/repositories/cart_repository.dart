import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Pure Dart domain contract defining cart operations.
/// Follows Clean Architecture: zero dependencies on external HTTP frameworks (Dio),
/// storage packages, or UI frameworks.
abstract class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCartItems();

  Future<Either<Failure, Unit>> addToCart(
    ProductEntity product, {
    String? selectedFlavor,
    String? selectedSize,
    int quantity = 1,
  });

  Future<Either<Failure, Unit>> removeFromCart(String itemId);

  Future<Either<Failure, Unit>> updateQuantity(String itemId, int quantity);

  Future<Either<Failure, Unit>> clearCart();
}
