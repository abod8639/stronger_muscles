import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart' as firebaseUser;
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/cart_item_model.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/auth_controller.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  late Box<CartItemModel> cartBox;

  @override
  void onInit() {
    super.onInit();
    _initBox();
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

  void addToCart(ProductModel product, {String? selectedFlavor}) {
    try {
      final existingItemIndex = cartItems.indexWhere(
        (item) =>
            item.productId == product.id &&
            item.selectedFlavor == selectedFlavor,
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
           userId:    Get.find<AuthController>().userId.value, // TODO: Get from auth controller
          productId: product.id,
          productName: product.name,
          price: product.effectivePrice,
          imageUrls: product.imageUrls,
          selectedFlavor: selectedFlavor,
          brand: product.brand,
          weight: product.weight,
          size: product.size,
          sku: product.sku,
          categoryId: product.categoryId,
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

  bool isInCart(ProductModel product, {String? selectedFlavor}) {
    return cartItems.any((item) =>
        item.productId == product.id && item.selectedFlavor == selectedFlavor);
  }

  CartItemModel? getCartItem(ProductModel product, {String? selectedFlavor}) {
    return cartItems.firstWhereOrNull((item) =>
        item.productId == product.id && item.selectedFlavor == selectedFlavor);
  }

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void clearCart() {
    try {
      cartBox.clear();
      cartItems.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to clear cart: $e');
    }
  }
}
