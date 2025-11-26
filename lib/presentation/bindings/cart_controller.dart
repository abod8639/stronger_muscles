import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/cart_item_model.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

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

  void addToCart(ProductModel product) {
    try {
      final existingItemIndex = cartItems.indexWhere(
        (item) => item.id == product.id,
      );
      if (existingItemIndex != -1) {
        final item = cartItems[existingItemIndex];
        item.quantity++;
        item.save(); // Hive object save
        cartItems.refresh();
      } else {
        final newItem = CartItemModel(
          id: product.id,
          name: product.name,
          price: product.price,
          imageUrl: product.imageUrl,
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
      item.delete(); // Hive object delete
      cartItems.remove(item);
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove from cart: $e');
    }
  }

  void increaseQuantity(CartItemModel item) {
    try {
      item.quantity++;
      item.save();
      cartItems.refresh();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update quantity: $e');
    }
  }

  void decreaseQuantity(CartItemModel item) {
    try {
      if (item.quantity > 1) {
        item.quantity--;
        item.save();
        cartItems.refresh();
      } else {
        removeFromCart(item);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update quantity: $e');
    }
  }

  bool isInCart(ProductModel product) {
    return cartItems.any((item) => item.id == product.id);
  }

  CartItemModel? getCartItem(ProductModel product) {
    return cartItems.firstWhereOrNull((item) => item.id == product.id);
  }

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
}
