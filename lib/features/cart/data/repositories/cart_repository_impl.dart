import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/errors.dart';
import 'package:stronger_muscles/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:stronger_muscles/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:stronger_muscles/features/cart/data/mappers/cart_mapper.dart';
import 'package:stronger_muscles/features/cart/data/models/cart_item_model.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Concrete implementation of [CartRepository] adhering to Clean Architecture and SOLID principles.
/// Acts as the Single Source of Truth, orchestrating calls between [CartRemoteDataSource] (Dio)
/// and [CartLocalDataSource] (Hive) with offline-first caching and centralized error handling.
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _localDataSource;
  final CartRemoteDataSource? _remoteDataSource;
  final String Function()? _getUserId;

  CartRepositoryImpl({
    required CartLocalDataSource localDataSource,
    CartRemoteDataSource? remoteDataSource,
    String Function()? getUserId,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _getUserId = getUserId;

  bool get _isAuthenticated {
    final uid = _getUserId?.call();
    return uid != null && uid.trim().isNotEmpty;
  }

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems() {
    return NetworkErrorHandler.execute(() async {
      // 1. Attempt fetching from remote data source if available and authenticated
      if (_remoteDataSource != null && _isAuthenticated) {
        try {
          final remoteModels = await _remoteDataSource.getCartItems();
          // Cache fresh data locally
          await _localDataSource.cacheAll(remoteModels);
          return remoteModels.map((m) => m.toEntity()).toList();
        } catch (_) {
          // Fall through to local cache on any network/remote error
        }
      }

      // 2. Fallback to local cache (offline-first & guest support)
      final localModels = await _localDataSource.getCartItems();
      return localModels.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, Unit>> addToCart(
    ProductEntity product, {
    String? selectedFlavor,
    String? selectedSize,
    int quantity = 1,
  }) {
    return NetworkErrorHandler.execute(() async {
      final currentModels = await _localDataSource.getCartItems();
      final existingIndex = currentModels.indexWhere(
        (m) =>
            m.product.id == product.id &&
            m.selectedFlavor == selectedFlavor &&
            m.selectedSize == selectedSize,
      );

      final String currentUserId = _getUserId?.call() ?? '';

      if (existingIndex != -1) {
        final existing = currentModels[existingIndex];
        final newQuantity = existing.quantity + quantity;

        if (product.stockQuantity > 0 && newQuantity > product.stockQuantity) {
          throw ValidationException(
            message:
                'الكمية المطلوبة تتجاوز المخزون المتوفر (${product.stockQuantity})',
          );
        }

        final updated = existing.copyWith(quantity: newQuantity);
        await _localDataSource.saveCartItem(updated);

        // Sync with remote asynchronously in background
        if (_remoteDataSource != null && _isAuthenticated) {
          unawaited(
            _remoteDataSource
                .updateQuantity(updated.id, newQuantity)
                .catchError((_) {}),
          );
        }
      } else {
        if (product.stockQuantity > 0 && quantity > product.stockQuantity) {
          throw ValidationException(
            message:
                'الكمية المطلوبة تتجاوز المخزون المتوفر (${product.stockQuantity})',
          );
        }

        final newItem = CartItemModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: currentUserId,
          product: ProductModel.fromEntity(product),
          quantity: quantity,
          selectedFlavor: selectedFlavor,
          selectedSize: selectedSize,
          addedAt: DateTime.now(),
        );

        await _localDataSource.saveCartItem(newItem);

        // Sync with remote asynchronously in background
        if (_remoteDataSource != null && _isAuthenticated) {
          unawaited(
            _remoteDataSource
                .addToCart(
                  productId: product.id,
                  selectedFlavor: selectedFlavor,
                  selectedSize: selectedSize,
                  quantity: quantity,
                )
                .catchError((_) {}),
          );
        }
      }

      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> removeFromCart(String itemId) {
    return NetworkErrorHandler.execute(() async {
      await _localDataSource.removeCartItem(itemId);

      if (_remoteDataSource != null && _isAuthenticated) {
        unawaited(
          _remoteDataSource.removeFromCart(itemId).catchError((_) {}),
        );
      }

      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> updateQuantity(String itemId, int quantity) {
    return NetworkErrorHandler.execute(() async {
      if (quantity <= 0) {
        await _localDataSource.removeCartItem(itemId);
        if (_remoteDataSource != null && _isAuthenticated) {
          unawaited(
            _remoteDataSource.removeFromCart(itemId).catchError((_) {}),
          );
        }
        return unit;
      }

      final models = await _localDataSource.getCartItems();
      final itemIndex = models.indexWhere((m) => m.id == itemId);
      if (itemIndex == -1) {
        throw const ValidationException(message: 'العنصر غير موجود في السلة');
      }

      final item = models[itemIndex];
      if (item.product.stockQuantity > 0 &&
          quantity > item.product.stockQuantity) {
        throw ValidationException(
          message:
              'الكمية المطلوبة تتجاوز المخزون المتوفر (${item.product.stockQuantity})',
        );
      }

      final updated = item.copyWith(quantity: quantity);
      await _localDataSource.saveCartItem(updated);

      if (_remoteDataSource != null && _isAuthenticated) {
        unawaited(
          _remoteDataSource
              .updateQuantity(itemId, quantity)
              .catchError((_) {}),
        );
      }

      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> clearCart() {
    return NetworkErrorHandler.execute(() async {
      await _localDataSource.clearCart();

      if (_remoteDataSource != null && _isAuthenticated) {
        unawaited(
          _remoteDataSource.clearCart().catchError((_) {}),
        );
      }

      return unit;
    });
  }
}
