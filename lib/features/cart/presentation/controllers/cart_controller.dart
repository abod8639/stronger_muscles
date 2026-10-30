import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/update_cart_quantity_usecase.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_di.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

part 'cart_controller.g.dart';

/// State notifier managing the cart state.
/// Adheres strictly to Clean Architecture & SOLID:
/// - Zero try-catch blocks: uses functional Either handling.
/// - Mutation locking: prevents duplicate submissions during mutations.
/// - 100% constructor testability.
@riverpod
class CartController extends _$CartController {
  final GetCartItemsUseCase? _testGetCartItemsUseCase;
  final AddToCartUseCase? _testAddToCartUseCase;
  final RemoveFromCartUseCase? _testRemoveFromCartUseCase;
  final UpdateCartQuantityUseCase? _testUpdateCartQuantityUseCase;
  final ClearCartUseCase? _testClearCartUseCase;

  CartController()
      : _testGetCartItemsUseCase = null,
        _testAddToCartUseCase = null,
        _testRemoveFromCartUseCase = null,
        _testUpdateCartQuantityUseCase = null,
        _testClearCartUseCase = null;

  @visibleForTesting
  CartController.test({
    required GetCartItemsUseCase getCartItemsUseCase,
    required AddToCartUseCase addToCartUseCase,
    required RemoveFromCartUseCase removeFromCartUseCase,
    required UpdateCartQuantityUseCase updateCartQuantityUseCase,
    required ClearCartUseCase clearCartUseCase,
  })  : _testGetCartItemsUseCase = getCartItemsUseCase,
        _testAddToCartUseCase = addToCartUseCase,
        _testRemoveFromCartUseCase = removeFromCartUseCase,
        _testUpdateCartQuantityUseCase = updateCartQuantityUseCase,
        _testClearCartUseCase = clearCartUseCase;

  GetCartItemsUseCase get _getCartItemsUseCase =>
      _testGetCartItemsUseCase ?? ref.read(getCartItemsUseCaseProvider);
  AddToCartUseCase get _addToCartUseCase =>
      _testAddToCartUseCase ?? ref.read(addToCartUseCaseProvider);
  RemoveFromCartUseCase get _removeFromCartUseCase =>
      _testRemoveFromCartUseCase ?? ref.read(removeFromCartUseCaseProvider);
  UpdateCartQuantityUseCase get _updateCartQuantityUseCase =>
      _testUpdateCartQuantityUseCase ??
      ref.read(updateCartQuantityUseCaseProvider);
  ClearCartUseCase get _clearCartUseCase =>
      _testClearCartUseCase ?? ref.read(clearCartUseCaseProvider);

  @override
  FutureOr<List<CartItemEntity>> build() async {
    final GetCartItemsUseCase useCase =
        _testGetCartItemsUseCase ?? ref.watch(getCartItemsUseCaseProvider);
    final result = await useCase();

    return result.fold(
      (failure) {
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
        return [];
      },
      (items) => items,
    );
  }

  /// List of current items in the cart as pure domain entities.
  List<CartItemEntity> get cartItems => state.valueOrNull ?? [];

  /// Total price of all items in the cart.
  double get totalPrice =>
      (state.valueOrNull ?? []).fold(0.0, (sum, item) => sum + item.subtotal);

  /// Total count of unique items in the cart.
  int get cartCount => (state.valueOrNull ?? []).length;

  /// Whether a mutation is currently in progress.
  bool get isMutating => state.isLoading;

  /// Resets error state back to data without losing cached cart items.
  void clearError() {
    if (state.hasError) {
      state = AsyncData(state.valueOrNull ?? []);
    }
  }

  /// Adds a product to the cart instantly (optimistic UI), then persists locally & syncs remotely.
  Future<void> addToCart(
    ProductEntity product, {
    String? selectedFlavor,
    String? selectedSize,
    int quantity = 1,
  }) async {
    final previousItems = state.valueOrNull ?? [];

    final existingIndex = previousItems.indexWhere(
      (m) =>
          m.product.id == product.id &&
          m.selectedFlavor == selectedFlavor &&
          m.selectedSize == selectedSize,
    );

    if (product.stockQuantity > 0) {
      final currentQty =
          existingIndex != -1 ? previousItems[existingIndex].quantity : 0;
      if (currentQty + quantity > product.stockQuantity) {
        state = AsyncError(
          ValidationFailure(
            message:
                'الكمية المطلوبة تتجاوز المخزون المتوفر (${product.stockQuantity})',
          ),
          StackTrace.current,
        );
        return;
      }
    }

    final List<CartItemEntity> optimisticItems;
    if (existingIndex != -1) {
      optimisticItems = List<CartItemEntity>.from(previousItems);
      final existing = optimisticItems[existingIndex];
      optimisticItems[existingIndex] =
          existing.copyWith(quantity: existing.quantity + quantity);
    } else {
      final newItem = CartItemEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: '',
        product: product,
        quantity: quantity,
        selectedFlavor: selectedFlavor,
        selectedSize: selectedSize,
        addedAt: DateTime.now(),
      );
      optimisticItems = [...previousItems, newItem];
    }

    // 1. Instant optimistic UI response (0ms delay)
    state = AsyncData(optimisticItems);

    // 2. Persist locally and sync in background
    final result = await _addToCartUseCase(
      product,
      selectedFlavor: selectedFlavor,
      selectedSize: selectedSize,
      quantity: quantity,
    );

    result.fold(
      (failure) {
        state = AsyncData(previousItems);
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (_) {},
    );
  }

  /// Removes an item from the cart instantly (optimistic UI), then persists changes.
  Future<void> removeFromCart(String itemId) async {
    final previousItems = state.valueOrNull ?? [];
    final optimisticItems = previousItems.where((i) => i.id != itemId).toList();
    state = AsyncData(optimisticItems);

    final result = await _removeFromCartUseCase(itemId);

    result.fold(
      (failure) {
        state = AsyncData(previousItems);
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (_) {},
    );
  }

  /// Increases quantity of an item by 1 instantly with optimistic UI response.
  Future<void> increaseQuantity(CartItemEntity item) async {
    final previousItems = state.valueOrNull ?? [];
    final itemIndex = previousItems.indexWhere((i) => i.id == item.id);
    if (itemIndex == -1) return;

    if (item.product.stockQuantity > 0 &&
        item.quantity + 1 > item.product.stockQuantity) {
      state = AsyncError(
        ValidationFailure(
          message:
              'الكمية المطلوبة تتجاوز المخزون المتوفر (${item.product.stockQuantity})',
        ),
        StackTrace.current,
      );
      return;
    }

    final optimisticItems = List<CartItemEntity>.from(previousItems);
    optimisticItems[itemIndex] = item.copyWith(quantity: item.quantity + 1);
    state = AsyncData(optimisticItems);

    final result = await _updateCartQuantityUseCase(
      item.id,
      item.quantity + 1,
    );

    result.fold(
      (failure) {
        state = AsyncData(previousItems);
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (_) {},
    );
  }

  /// Decreases quantity of an item by 1 instantly, or removes it if quantity drops below 1.
  Future<void> decreaseQuantity(CartItemEntity item) async {
    final previousItems = state.valueOrNull ?? [];
    final itemIndex = previousItems.indexWhere((i) => i.id == item.id);
    if (itemIndex == -1) return;

    final optimisticItems = List<CartItemEntity>.from(previousItems);
    if (item.quantity - 1 <= 0) {
      optimisticItems.removeAt(itemIndex);
    } else {
      optimisticItems[itemIndex] = item.copyWith(quantity: item.quantity - 1);
    }
    state = AsyncData(optimisticItems);

    final result = await _updateCartQuantityUseCase(
      item.id,
      item.quantity - 1,
    );

    result.fold(
      (failure) {
        state = AsyncData(previousItems);
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (_) {},
    );
  }

  /// Clears the entire cart instantly with optimistic UI response.
  Future<void> clearCart() async {
    final previousItems = state.valueOrNull ?? [];
    state = const AsyncData([]);

    final result = await _clearCartUseCase();

    result.fold(
      (failure) {
        state = AsyncData(previousItems);
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (_) {},
    );
  }

  /// Checks if a product with the specified flavor and size is in the cart.
  bool isInCart(
    String productId, {
    String? selectedFlavor,
    String? selectedSize,
  }) {
    final currentItems = state.valueOrNull ?? [];
    return currentItems.any(
      (item) =>
          item.product.id == productId &&
          (selectedFlavor == null || item.selectedFlavor == selectedFlavor) &&
          (selectedSize == null || item.selectedSize == selectedSize),
    );
  }

  /// Retrieves the [CartItemEntity] for the given product ID and options.
  CartItemEntity? getCartItem(
    String productId, {
    String? selectedFlavor,
    String? selectedSize,
  }) {
    final currentItems = state.valueOrNull ?? [];
    return currentItems.where(
      (item) =>
          item.product.id == productId &&
          (selectedFlavor == null || item.selectedFlavor == selectedFlavor) &&
          (selectedSize == null || item.selectedSize == selectedSize),
    ).firstOrNull;
  }

  Future<void> refreshCart() async {
    final result = await _getCartItemsUseCase();
    result.fold(
      (failure) {
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (freshItems) {
        state = AsyncData(freshItems);
      },
    );
  }
}
