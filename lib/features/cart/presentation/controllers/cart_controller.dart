import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:stronger_muscles/features/cart/data/models/cart_item_model.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/domain/usecases/usecase_providers.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

part 'cart_controller.g.dart';

@riverpod
class CartController extends _$CartController {
  @override
  FutureOr<List<CartItemEntity>> build() async {
    if (!Hive.isBoxOpen(CartLocalDataSourceImpl.boxName)) {
      await Hive.openBox<CartItemModel>(CartLocalDataSourceImpl.boxName);
    }
    final getCartItems = ref.watch(getCartItemsUseCaseProvider);
    return getCartItems();
  }

  /// List of current items in the cart as domain entities.
  List<CartItemEntity> get cartItems => state.value ?? [];

  ProductEntity _ensureEntity(dynamic product) {
    if (product is ProductEntity) return product;
    if (product is ProductModel) return product.toEntity();
    throw ArgumentError(
      'Expected ProductEntity or ProductModel, but received: ${product.runtimeType}',
    );
  }

  String _extractItemId(dynamic item) {
    if (item is CartItemEntity) return item.id;
    if (item is CartItemModel) return item.id;
    if (item is String) return item;
    throw ArgumentError('Expected CartItemEntity, CartItemModel or String id');
  }

  int _extractItemQuantity(dynamic item) {
    if (item is CartItemEntity) return item.quantity;
    if (item is CartItemModel) return item.quantity;
    return 1;
  }

  /// Adds a product to the cart using [AddToCartUseCase].
  Future<void> addToCart(
    dynamic product, {
    String? selectedFlavor,
    String? selectedSize,
    int quantity = 1,
  }) async {
    final entity = _ensureEntity(product);
    final addUseCase = ref.read(addToCartUseCaseProvider);
    await addUseCase(
      entity,
      selectedFlavor: selectedFlavor,
      selectedSize: selectedSize,
      quantity: quantity,
    );
    final getCartItems = ref.read(getCartItemsUseCaseProvider);
    state = AsyncData(await getCartItems());
  }

  /// Removes a cart item using [RemoveFromCartUseCase].
  Future<void> removeFromCart(dynamic item) async {
    final itemId = _extractItemId(item);
    final removeUseCase = ref.read(removeFromCartUseCaseProvider);
    await removeUseCase(itemId);
    final getCartItems = ref.read(getCartItemsUseCaseProvider);
    state = AsyncData(await getCartItems());
  }

  /// Increases quantity of an item using [UpdateCartQuantityUseCase].
  Future<void> increaseQuantity(dynamic item) async {
    final itemId = _extractItemId(item);
    final currentQty = _extractItemQuantity(item);
    final updateUseCase = ref.read(updateCartQuantityUseCaseProvider);
    await updateUseCase(itemId, currentQty + 1);
    final getCartItems = ref.read(getCartItemsUseCaseProvider);
    state = AsyncData(await getCartItems());
  }

  /// Decreases quantity of an item or removes it if quantity becomes 0.
  Future<void> decreaseQuantity(dynamic item) async {
    final itemId = _extractItemId(item);
    final currentQty = _extractItemQuantity(item);
    final updateUseCase = ref.read(updateCartQuantityUseCaseProvider);
    await updateUseCase(itemId, currentQty - 1);
    final getCartItems = ref.read(getCartItemsUseCaseProvider);
    state = AsyncData(await getCartItems());
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
    final currentItems = state.value ?? [];
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
    final currentItems = state.value ?? [];
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
      (state.value ?? []).fold(0.0, (sum, item) => sum + item.subtotal);

  /// Number of unique items in cart.
  int get cartCount => (state.value ?? []).length;

  /// Clears the entire cart using [ClearCartUseCase].
  Future<void> clearCart() async {
    final clearUseCase = ref.read(clearCartUseCaseProvider);
    await clearUseCase();
    state = const AsyncData([]);
  }
}
