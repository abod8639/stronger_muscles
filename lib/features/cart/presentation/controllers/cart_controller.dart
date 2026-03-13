import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/features/cart/data/models/cart_item_model.dart';

part 'cart_controller.g.dart';

const String _cartBoxName = 'cart';

@riverpod
class CartController extends _$CartController {
  late Box<CartItemModel> _cartBox;
  final TextEditingController notesController = TextEditingController();

  @override
  FutureOr<List<CartItemModel>> build() async {
    ref.onDispose(() {
      notesController.dispose();
    });

    if (!Hive.isBoxOpen(_cartBoxName)) {
      _cartBox = await Hive.openBox<CartItemModel>(_cartBoxName);
    } else {
      _cartBox = Hive.box<CartItemModel>(_cartBoxName);
    }
    return _cartBox.values.toList();
  }

  List<CartItemModel> get cartItems => state.value ?? [];

  Future<void> addToCart(
    ProductModel product, {
    String? selectedFlavor,
    String? selectedSize,
  }) async {
    final authController = ref.read(authControllerProvider.notifier);
    final userId = authController.currentUser?.id.toString() ?? "";

    final currentItems = state.value ?? [];
    final existingItemIndex = currentItems.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedFlavor == selectedFlavor &&
          item.selectedSize == selectedSize,
    );

    if (existingItemIndex != -1) {
      final item = currentItems[existingItemIndex];
      final updatedItem = item.copyWith(quantity: item.quantity + 1);
      await _cartBox.putAt(existingItemIndex, updatedItem);
    } else {
      final newItem = CartItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        product: product,
        selectedFlavor: selectedFlavor,
        selectedSize: selectedSize,
        addedAt: DateTime.now(),
      );
      await _cartBox.add(newItem);
    }

    state = AsyncData(_cartBox.values.toList());
  }

  Future<void> removeFromCart(CartItemModel item) async {
    final currentItems = state.value ?? [];
    final index = currentItems.indexOf(item);
    if (index != -1) {
      await _cartBox.deleteAt(index);
      state = AsyncData(_cartBox.values.toList());
    }
  }

  Future<void> increaseQuantity(CartItemModel item) async {
    final currentItems = state.value ?? [];
    final index = currentItems.indexOf(item);
    if (index != -1) {
      final updatedItem = item.copyWith(quantity: item.quantity + 1);
      await _cartBox.putAt(index, updatedItem);
      state = AsyncData(_cartBox.values.toList());
    }
  }

  Future<void> decreaseQuantity(CartItemModel item) async {
    final currentItems = state.value ?? [];
    final index = currentItems.indexOf(item);
    if (index != -1) {
      if (item.quantity > 1) {
        final updatedItem = item.copyWith(quantity: item.quantity - 1);
        await _cartBox.putAt(index, updatedItem);
      } else {
        await _cartBox.deleteAt(index);
      }
      state = AsyncData(_cartBox.values.toList());
    }
  }

  bool isInCart(
    ProductModel product, {
    String? selectedFlavor,
    String? selectedSize,
  }) {
    final currentItems = state.value ?? [];
    return currentItems.any(
      (item) =>
          item.product.id == product.id &&
          item.selectedFlavor == selectedFlavor &&
          item.selectedSize == selectedSize,
    );
  }

  CartItemModel? getCartItem(
    ProductModel product, {
    String? selectedFlavor,
    String? selectedSize,
  }) {
    final currentItems = state.value ?? [];
    try {
      return currentItems.firstWhere(
        (item) =>
            item.product.id == product.id &&
            item.selectedFlavor == selectedFlavor &&
            item.selectedSize == selectedSize,
      );
    } catch (_) {
      return null;
    }
  }

  double get totalPrice =>
      (state.value ?? []).fold(0.0, (sum, item) => sum + item.subtotal);

  int get cartCount => (state.value ?? []).length;

  Future<void> clearCart() async {
    await _cartBox.clear();
    notesController.clear();
    state = const AsyncData([]);
  }
}
