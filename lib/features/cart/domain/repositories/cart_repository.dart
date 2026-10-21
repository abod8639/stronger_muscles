import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Domain contract defining cart operations returning [Either<Failure, T>] for safe error handling.
abstract class CartRepository {
  Future<Either<Failure, List<CartItemEntity>>> getCartItems({
    CancelToken? cancelToken,
  });

  Future<Either<Failure, Unit>> addToCart(
    ProductEntity product, {
    String? selectedFlavor,
    String? selectedSize,
    int quantity = 1,
    CancelToken? cancelToken,
  });

  Future<Either<Failure, Unit>> removeFromCart(
    String itemId, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, Unit>> updateQuantity(
    String itemId,
    int quantity, {
    CancelToken? cancelToken,
  });

  Future<Either<Failure, Unit>> clearCart({
    CancelToken? cancelToken,
  });
}
