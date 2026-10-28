import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/errors/errors.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/usecase_providers.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

part 'cart_controller.g.dart';

@riverpod
class CartController extends _$CartController {
  CancelToken _cancelToken = CancelToken();

  @override
  FutureOr<List<CartItemEntity>> build() async {
    _cancelToken = CancelToken();

    // Cancel active operations on dispose to prevent resource leaks
    ref.onDispose(() {
      if (!_cancelToken.isCancelled) {
        _cancelToken.cancel('CartController disposed');
      }
    });

    final getCartItems = ref.watch(getCartItemsUseCaseProvider);
    final result = await getCartItems(cancelToken: _cancelToken);

    return result.fold(
      (failure) => throw failure,
      (items) => items,
    );
  }

  /// List of current items in the cart as domain entities.
  List<CartItemEntity> get cartItems => state.valueOrNull ?? [];

  /// Resets error state back to data without losing cached cart items.
  void clearError() {
    if (state.hasError) {
      state = AsyncData(state.valueOrNull ?? []);
    }
  }

  ProductEntity? _resolveEntity(dynamic product) {
    if (product is ProductEntity) return product;
    if (product is ProductModel) return product.toEntity();
    return null;
  }

  String? _resolveItemId(dynamic item) {
    if (item is CartItemEntity) return item.id;
    if (item is String) return item;
    return null;
  }

  int _resolveItemQuantity(dynamic item) {
    if (item is CartItemEntity) return item.quantity;
    return 1;
  }

  /// Adds a product to the cart using [AddToCartUseCase].
  Future<void> addToCart(
    dynamic product, {
    String? selectedFlavor,
    String? selectedSize,
    int quantity = 1,
  }) async {
    final entity = _resolveEntity(product);
    if (entity == null) {
      state = AsyncError(
        const ValidationFailure(message: 'بيانات المنتج غير صالحة للإضافة إلى السلة'),
        StackTrace.current,
      );
      return;
    }

    final addUseCase = ref.read(addToCartUseCaseProvider);
    final result = await addUseCase(
      entity,
      selectedFlavor: selectedFlavor,
      selectedSize: selectedSize,
      quantity: quantity,
      cancelToken: _cancelToken,
    );

    await result.fold(
      (failure) async {
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (_) async {
        await _refreshCart();
      },
    );
  }

  /// Removes a cart item using [RemoveFromCartUseCase].
  Future<void> removeFromCart(dynamic item) async {
    final itemId = _resolveItemId(item);
    if (itemId == null) return;

    final removeUseCase = ref.read(removeFromCartUseCaseProvider);
    final result = await removeUseCase(itemId, cancelToken: _cancelToken);

    await result.fold(
      (failure) async {
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (_) async {
        await _refreshCart();
      },
    );
  }

  /// Increases quantity of an item using [UpdateCartQuantityUseCase].
  Future<void> increaseQuantity(dynamic item) async {
    final itemId = _resolveItemId(item);
    if (itemId == null) return;
    final currentQty = _resolveItemQuantity(item);

    final updateUseCase = ref.read(updateCartQuantityUseCaseProvider);
    final result = await updateUseCase(
      itemId,
      currentQty + 1,
      cancelToken: _cancelToken,
    );

    await result.fold(
      (failure) async {
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (_) async {
        await _refreshCart();
      },
    );
  }

  /// Decreases quantity of an item or removes it if quantity reaches 0.
  Future<void> decreaseQuantity(dynamic item) async {
    final itemId = _resolveItemId(item);
    if (itemId == null) return;
    final currentQty = _resolveItemQuantity(item);

    final updateUseCase = ref.read(updateCartQuantityUseCaseProvider);
    final result = await updateUseCase(
      itemId,
      currentQty - 1,
      cancelToken: _cancelToken,
    );

    await result.fold(
      (failure) async {
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (_) async {
        await _refreshCart();
      },
    );
  }

  Future<void> _refreshCart() async {
    final getCartItems = ref.read(getCartItemsUseCaseProvider);
    final freshResult = await getCartItems(cancelToken: _cancelToken);
    freshResult.fold(
      (failure) {
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (freshItems) {
        state = AsyncData(freshItems);
      },
    );
  }

  /// Checks if a product with matching options is already in the cart.
  bool isInCart(
    dynamic product, {
    String? selectedFlavor,
    String? selectedSize,
  }) {
    final id = product is ProductEntity
        ? product.id
        : (product is ProductModel ? product.id : product.toString());
    final currentItems = state.valueOrNull ?? [];
    return currentItems.any(
      (item) =>
          item.product.id == id &&
          (selectedFlavor == null || item.selectedFlavor == selectedFlavor) &&
          (selectedSize == null || item.selectedSize == selectedSize),
    );
  }

  /// Retrieves the [CartItemEntity] for the given product.
  CartItemEntity? getCartItem(
    dynamic product, {
    String? selectedFlavor,
    String? selectedSize,
  }) {
    final id = product is ProductEntity
        ? product.id
        : (product is ProductModel ? product.id : product.toString());
    final currentItems = state.valueOrNull ?? [];
    try {
      return currentItems.firstWhere(
        (item) =>
            item.product.id == id &&
            (selectedFlavor == null || item.selectedFlavor == selectedFlavor) &&
            (selectedSize == null || item.selectedSize == selectedSize),
      );
    } catch (_) {
      return null;
    }
  }

  /// Calculates total price of all items in cart.
  double get totalPrice =>
      (state.valueOrNull ?? []).fold(0.0, (sum, item) => sum + item.subtotal);

  /// Number of unique items in cart.
  int get cartCount => (state.valueOrNull ?? []).length;

  /// Clears the entire cart using [ClearCartUseCase].
  Future<void> clearCart() async {
    final clearUseCase = ref.read(clearCartUseCaseProvider);
    final result = await clearUseCase(cancelToken: _cancelToken);

    result.fold(
      (failure) {
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (_) {
        state = const AsyncData([]);
      },
    );
  }
}
