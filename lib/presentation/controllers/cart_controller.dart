import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/cart_item_model.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/controllers/auth_controller.dart';
import 'base_controller.dart';

const String _cartBoxName = 'cart';
const String _cartErrorMsg = 'فشل تحميل عناصر السلة';
const String _addErrorMsg = 'فشل إضافة المنتج إلى السلة';
const String _removeErrorMsg = 'فشل إزالة المنتج من السلة';

class CartController extends BaseController {
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  late Box<CartItemModel> cartBox;

  late TextEditingController notesController;
  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    _initBox();
    notesController = TextEditingController();
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  Future<void> _initBox() async {
    try {
      setLoading(true);
      if (!Hive.isBoxOpen(_cartBoxName)) {
        cartBox = await Hive.openBox<CartItemModel>(_cartBoxName);
      } else {
        cartBox = Hive.box<CartItemModel>(_cartBoxName);
      }
      cartItems.assignAll(cartBox.values.toList());
    } catch (e) {
      handleError(e, message: _cartErrorMsg);
    } finally {
      setLoading(false);
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

        cartBox.putAt(existingItemIndex, updatedItem);
        cartItems[existingItemIndex] = updatedItem;
      } else {
        final newItem = CartItemModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: _authController.userId.value,
          product: product,
          selectedFlavor: selectedFlavor,
          selectedSize: selectedSize,
          addedAt: DateTime.now(),
        );
        cartBox.add(newItem);
        cartItems.add(newItem);
      }
    } catch (e) {
      handleError(e, title: 'خطأ', message: _addErrorMsg);
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
      handleError(e, title: 'خطأ', message: _removeErrorMsg);
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
      handleError(e, message: 'فشل تحديث الكمية');
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
      handleError(e, message: 'فشل تحديث الكمية');
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
      handleError(e, message: 'فشل مسح السلة');
    }
  }
}
