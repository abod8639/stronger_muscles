import 'package:stronger_muscles/features/cart/data/datasources/cart_local_data_source.dart';
import 'package:stronger_muscles/features/cart/data/models/cart_item_model.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Concrete implementation of [CartRepository] adhering to Clean Architecture.
/// Coordinates between [CartLocalDataSource] and the domain layer.
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _localDataSource;
  final String Function() _getUserId;

  CartRepositoryImpl({
    required CartLocalDataSource localDataSource,
    required String Function() getUserId,
  })  : _localDataSource = localDataSource,
        _getUserId = getUserId;

  @override
  Future<List<CartItemEntity>> getCartItems() async {
    final models = await _localDataSource.getCartItems();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addToCart(
    ProductEntity product, {
    String? selectedFlavor,
    String? selectedSize,
    int quantity = 1,
  }) async {
    final currentModels = await _localDataSource.getCartItems();
    final existingIndex = currentModels.indexWhere(
      (m) =>
          m.product.id == product.id &&
          m.selectedFlavor == selectedFlavor &&
          m.selectedSize == selectedSize,
    );

    if (existingIndex != -1) {
      final existing = currentModels[existingIndex];
      if (product.stockQuantity > 0 &&
          existing.quantity >= product.stockQuantity) {
        return;
      }
      final updated = existing.copyWith(quantity: existing.quantity + quantity);
      await _localDataSource.saveCartItem(updated);
    } else {
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
  }

  @override
  Future<void> removeFromCart(String itemId) async {
    await _localDataSource.removeCartItem(itemId);
  }

  @override
  Future<void> updateQuantity(String itemId, int quantity) async {
    if (quantity <= 0) {
      await _localDataSource.removeCartItem(itemId);
      return;
    }
    final models = await _localDataSource.getCartItems();
    final itemIndex = models.indexWhere((m) => m.id == itemId);
    if (itemIndex == -1) return;

    final item = models[itemIndex];
    if (item.product.stockQuantity > 0 &&
        quantity > item.product.stockQuantity) {
      return;
    }
    await _localDataSource.saveCartItem(item.copyWith(quantity: quantity));
  }

  @override
  Future<void> clearCart() async {
    await _localDataSource.clearCart();
  }
}
