import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/errors/errors.dart';
import 'package:stronger_muscles/features/cart/data/models/cart_item_model.dart';

/// Local data source contract for cart storage via Hive.
abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> saveCartItem(CartItemModel item);
  Future<void> cacheAll(List<CartItemModel> items);
  Future<void> removeCartItem(String itemId);
  Future<void> clearCart();
}

/// Hive implementation of [CartLocalDataSource] with self-healing box initialization
/// and typed exception mapping.
class CartLocalDataSourceImpl implements CartLocalDataSource {
  static const String boxName = 'cart';
  Box<CartItemModel>? _box;

  CartLocalDataSourceImpl([this._box]);

  static Future<CartLocalDataSourceImpl> init() async {
    final box = await _openSafeBox();
    return CartLocalDataSourceImpl(box);
  }

  static Future<Box<CartItemModel>> _openSafeBox() async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        return Hive.box<CartItemModel>(boxName);
      }
      return await Hive.openBox<CartItemModel>(boxName);
    } catch (e) {
      throw ServerException(
        message: 'فشل في تهيئة قاعدة البيانات المحلية للسلة',
        data: e,
      );
    }
  }

  Future<Box<CartItemModel>> _ensureBox() async {
    if (_box != null && _box!.isOpen) {
      return _box!;
    }
    _box = await _openSafeBox();
    return _box!;
  }

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final box = await _ensureBox();
      return box.values.toList();
    } catch (e) {
      throw ParsingException(
        message: 'تعذر قراءة عناصر السلة من الذاكرة المحلية',
        originalError: e,
      );
    }
  }

  @override
  Future<void> saveCartItem(CartItemModel item) async {
    try {
      final box = await _ensureBox();
      await box.put(item.id, item);
    } catch (e) {
      throw ServerException(
        message: 'تعذر حفظ العنصر في السلة المحلية',
        data: e,
      );
    }
  }

  @override
  Future<void> cacheAll(List<CartItemModel> items) async {
    try {
      final box = await _ensureBox();
      await box.clear();
      final map = {for (final item in items) item.id: item};
      await box.putAll(map);
    } catch (e) {
      throw ServerException(
        message: 'تعذر تحديث ذاكرة السلة المحلية',
        data: e,
      );
    }
  }

  @override
  Future<void> removeCartItem(String itemId) async {
    try {
      final box = await _ensureBox();
      await box.delete(itemId);
    } catch (e) {
      throw ServerException(
        message: 'تعذر حذف العنصر من السلة',
        data: e,
      );
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      final box = await _ensureBox();
      await box.clear();
    } catch (e) {
      throw ServerException(
        message: 'تعذر تفريغ السلة',
        data: e,
      );
    }
  }
}
