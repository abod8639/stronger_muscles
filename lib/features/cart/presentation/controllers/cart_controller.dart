import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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

  bool _isMutating = false;

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
  bool get isMutating => _isMutating;

  /// Resets error state back to data without losing cached cart items.
  void clearError() {
    if (state.hasError) {
      state = AsyncData(state.valueOrNull ?? []);
    }
  }

  /// Adds a product to the cart with duplicate submission guard.
  Future<void> addToCart(
    ProductEntity product, {
    String? selectedFlavor,
    String? selectedSize,
    int quantity = 1,
  }) async {
    if (_isMutating) return;
    _isMutating = true;

    final result = await _addToCartUseCase(
      product,
      selectedFlavor: selectedFlavor,
      selectedSize: selectedSize,
      quantity: quantity,
    );

    result.fold(
      (failure) {
        _isMutating = false;
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (_) async {
        await _refreshCart();
        _isMutating = false;
      },
    );
  }

  /// Removes an item from the cart by its ID.
  Future<void> removeFromCart(String itemId) async {
    if (_isMutating) return;
    _isMutating = true;

    final result = await _removeFromCartUseCase(itemId);

    result.fold(
      (failure) {
        _isMutating = false;
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (_) async {
        await _refreshCart();
        _isMutating = false;
      },
    );
  }

  /// Increases quantity of an item by 1.
  Future<void> increaseQuantity(CartItemEntity item) async {
    if (_isMutating) return;
    _isMutating = true;

    final result = await _updateCartQuantityUseCase(
      item.id,
      item.quantity + 1,
    );

    result.fold(
      (failure) {
        _isMutating = false;
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (_) async {
        await _refreshCart();
        _isMutating = false;
      },
    );
  }

  /// Decreases quantity of an item by 1, or removes it if quantity drops below 1.
  Future<void> decreaseQuantity(CartItemEntity item) async {
    if (_isMutating) return;
    _isMutating = true;

    final result = await _updateCartQuantityUseCase(
      item.id,
      item.quantity - 1,
    );

    result.fold(
      (failure) {
        _isMutating = false;
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (_) async {
        await _refreshCart();
        _isMutating = false;
      },
    );
  }

  /// Clears the entire cart with duplicate submission guard.
  Future<void> clearCart() async {
    if (_isMutating) return;
    _isMutating = true;

    final result = await _clearCartUseCase();

    result.fold(
      (failure) {
        _isMutating = false;
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (_) {
        _isMutating = false;
        state = const AsyncData([]);
      },
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

  Future<void> _refreshCart() async {
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
