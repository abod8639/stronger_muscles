import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/cart/data/models/cart_item_model.dart';

/// Local data source contract for cart storage.
abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> saveCartItem(CartItemModel item);
  Future<void> removeCartItem(String itemId);
  Future<void> clearCart();
}

/// Hive implementation of [CartLocalDataSource].
class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String boxName = 'cart';
  final Box<CartItemModel> _box;

  CartLocalDataSourceImpl(this._box);

  static Future<CartLocalDataSourceImpl> init() async {
    final box = Hive.isBoxOpen(boxName)
        ? Hive.box<CartItemModel>(boxName)
        : await Hive.openBox<CartItemModel>(boxName);
    return CartLocalDataSourceImpl(box);
  }

  @override
  Future<List<CartItemModel>> getCartItems() async {
    return _box.values.toList();
  }

  @override
  Future<void> saveCartItem(CartItemModel item) async {
    await _box.put(item.id, item);
  }

  @override
  Future<void> removeCartItem(String itemId) async {
    await _box.delete(itemId);
  }

  @override
  Future<void> clearCart() async {
    await _box.clear();
  }
}
