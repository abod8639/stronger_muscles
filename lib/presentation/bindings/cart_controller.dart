import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/cart_item_model.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/auth_controller.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  late Box<CartItemModel> cartBox;

  late TextEditingController notesController;
  @override
  void onInit() {
    super.onInit();
    _initBox();
    notesController = TextEditingController();
  }

  Future<void> _initBox() async {
    try {
      if (!Hive.isBoxOpen('cart')) {
        cartBox = await Hive.openBox<CartItemModel>('cart');
      } else {
        cartBox = Hive.box<CartItemModel>('cart');
      }
      cartItems.assignAll(cartBox.values.toList());
    } catch (e) {
      Get.snackbar('Error', 'Failed to load cart items: $e');
    }
  }

  void addToCart(
    ProductModel product, {
    String? selectedFlavor,
    String? selectedSize,
  }) {
    try {
      final existingItemIndex = cartItems.indexWhere(
        (item) =>
            item.product.id == product.id &&
            item.selectedFlavor == selectedFlavor &&
            item.selectedSize == selectedSize,
      );
      if (existingItemIndex != -1) {
        final item = cartItems[existingItemIndex];
        final updatedItem = item.copyWith(quantity: item.quantity + 1);

        // Update both the box and the observable list
        cartBox.putAt(existingItemIndex, updatedItem);
        cartItems[existingItemIndex] = updatedItem;
      } else {
        final newItem = CartItemModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: Get.find<AuthController>().userId.value,
          product: product,
          selectedFlavor: selectedFlavor,
          selectedSize: selectedSize,
          addedAt: DateTime.now(),
        );
        cartBox.add(newItem);
        cartItems.add(newItem);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add to cart: $e');
    }
  }

  void removeFromCart(CartItemModel item) {
    try {
      final index = cartItems.indexOf(item);
      if (index != -1) {
        cartBox.deleteAt(index);
        cartItems.removeAt(index);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove from cart: $e');
    }
  }

  void increaseQuantity(CartItemModel item) {
    try {
      final index = cartItems.indexOf(item);
      if (index != -1) {
        final updatedItem = item.copyWith(quantity: item.quantity + 1);
        cartBox.putAt(index, updatedItem);
        cartItems[index] = updatedItem;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update quantity: $e');
    }
  }

  void decreaseQuantity(CartItemModel item) {
    try {
      final index = cartItems.indexOf(item);
      if (index != -1) {
        if (item.quantity > 1) {
          final updatedItem = item.copyWith(quantity: item.quantity - 1);
          cartBox.putAt(index, updatedItem);
          cartItems[index] = updatedItem;
        } else {
          removeFromCart(item);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update quantity: $e');
    }
  }

  bool isInCart(
    ProductModel product, {
    String? selectedFlavor,
    String? selectedSize,
  }) {
    return cartItems.any(
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
    return cartItems.firstWhereOrNull(
      (item) =>
          item.product.id == product.id &&
          item.selectedFlavor == selectedFlavor &&
          item.selectedSize == selectedSize,
    );
  }

  double get totalPrice => cartItems.fold(
    0,
    (sum, item) => sum + (item.product.effectivePrice * item.quantity),
  );

  void clearCart() {
    try {
      cartBox.clear();
      cartItems.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to clear cart: $e');
    }
  }
}
