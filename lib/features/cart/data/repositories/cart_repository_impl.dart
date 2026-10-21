import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/errors.dart';
import 'package:stronger_muscles/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:stronger_muscles/features/cart/data/models/cart_item_model.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Concrete implementation of [CartRepository] adhering to Clean Architecture.
/// Coordinates between [CartLocalDataSource] and the domain layer with centralized error handling.
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _localDataSource;
  final String Function() _getUserId;

  CartRepositoryImpl({
    required CartLocalDataSource localDataSource,
    required String Function() getUserId,
  })  : _localDataSource = localDataSource,
        _getUserId = getUserId;

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems({
    CancelToken? cancelToken,
  }) {
    return NetworkErrorHandler.execute(() async {
      final models = await _localDataSource.getCartItems();
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, Unit>> addToCart(
    ProductEntity product, {
    String? selectedFlavor,
    String? selectedSize,
    int quantity = 1,
    CancelToken? cancelToken,
  }) {
    return NetworkErrorHandler.execute(() async {
      final currentModels = await _localDataSource.getCartItems();
      final existingIndex = currentModels.indexWhere(
        (m) =>
            m.product.id == product.id &&
            m.selectedFlavor == selectedFlavor &&
            m.selectedSize == selectedSize,
      );

      if (existingIndex != -1) {
        final existing = currentModels[existingIndex];
        final newQuantity = existing.quantity + quantity;

        if (product.stockQuantity > 0 && newQuantity > product.stockQuantity) {
          throw ValidationException(
            message: 'الكمية المطلوبة تتجاوز المخزون المتوفر (${product.stockQuantity})',
          );
        }

        final updated = existing.copyWith(quantity: newQuantity);
        await _localDataSource.saveCartItem(updated);
      } else {
        if (product.stockQuantity > 0 && quantity > product.stockQuantity) {
          throw ValidationException(
            message: 'الكمية المطلوبة تتجاوز المخزون المتوفر (${product.stockQuantity})',
          );
        }

        final newItem = CartItemModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: _getUserId(),
          product: ProductModel.fromEntity(product),
          quantity: quantity,
          selectedFlavor: selectedFlavor,
          selectedSize: selectedSize,
          addedAt: DateTime.now(),
        );
        await _localDataSource.saveCartItem(newItem);
      }

      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> removeFromCart(
    String itemId, {
    CancelToken? cancelToken,
  }) {
    return NetworkErrorHandler.execute(() async {
      await _localDataSource.removeCartItem(itemId);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> updateQuantity(
    String itemId,
    int quantity, {
    CancelToken? cancelToken,
  }) {
    return NetworkErrorHandler.execute(() async {
      if (quantity <= 0) {
        await _localDataSource.removeCartItem(itemId);
        return unit;
      }

      final models = await _localDataSource.getCartItems();
      final itemIndex = models.indexWhere((m) => m.id == itemId);
      if (itemIndex == -1) {
        throw const ValidationException(message: 'العنصر غير موجود في السلة');
      }

      final item = models[itemIndex];
      if (item.product.stockQuantity > 0 && quantity > item.product.stockQuantity) {
        throw ValidationException(
          message: 'الكمية المطلوبة تتجاوز المخزون المتوفر (${item.product.stockQuantity})',
        );
      }

      await _localDataSource.saveCartItem(item.copyWith(quantity: quantity));
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> clearCart({
    CancelToken? cancelToken,
  }) {
    return NetworkErrorHandler.execute(() async {
      await _localDataSource.clearCart();
      return unit;
    });
  }
}
