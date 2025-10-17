
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
    cartBox = Hive.box<CartItemModel>('cart');
    cartItems.assignAll(cartBox.values.toList());
  }

  void addToCart(ProductModel product) {
    final existingItemIndex = cartItems.indexWhere((item) => item.id == product.id);
    if (existingItemIndex != -1) {
      cartItems[existingItemIndex].quantity++;
    } else {
      final newItem = CartItemModel(
        id: product.id,
        name: product.name,
        price: product.price,
        imageUrl: product.imageUrl.last, // Use the last image URL
      );
      cartItems.add(newItem);
      cartBox.add(newItem);
    }
    cartItems.refresh();
  }

  void removeFromCart(CartItemModel item) {
    cartItems.remove(item);
    cartBox.delete(item.key);
  }

  void increaseQuantity(CartItemModel item) {
    item.quantity++;
    cartBox.put(item.key, item);
    cartItems.refresh();
  }

  void decreaseQuantity(CartItemModel item) {
    if (item.quantity > 1) {
      item.quantity--;
      cartBox.put(item.key, item);
      cartItems.refresh();
    } else {
      removeFromCart(item);
    }
  }

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
}
