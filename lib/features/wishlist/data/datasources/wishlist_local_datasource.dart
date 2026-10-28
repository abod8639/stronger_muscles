import 'package:hive/hive.dart';

/// Contract for local caching of wishlist data.
abstract class WishlistLocalDataSource {
  /// Loads all raw stored JSON strings from local cache.
  List<String> getAllRaw();

  /// Checks if a product exists in the local cache.
  bool contains(String productId);

  /// Stores a product's serialized JSON string keyed by product ID.
  void put(String productId, String jsonString);

  /// Removes a product from local cache.
  void remove(String productId);

  /// Clears all items from the local cache.
  void clear();
}

/// Hive-backed implementation of [WishlistLocalDataSource] with resilient in-memory fallback.
class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  final Box<String>? _box;
  final Map<String, String> _inMemoryFallback = {};

  WishlistLocalDataSourceImpl([this._box]);

  @override
  List<String> getAllRaw() {
    final box = _box;
    if (box != null && box.isOpen) {
      return box.values.toList();
    }
    return _inMemoryFallback.values.toList();
  }

  @override
  bool contains(String productId) {
    final box = _box;
    if (box != null && box.isOpen) {
      return box.containsKey(productId);
    }
    return _inMemoryFallback.containsKey(productId);
  }

  @override
  void put(String productId, String jsonString) {
    final box = _box;
    if (box != null && box.isOpen) {
      box.put(productId, jsonString);
    } else {
      _inMemoryFallback[productId] = jsonString;
    }
  }

  @override
  void remove(String productId) {
    final box = _box;
    if (box != null && box.isOpen) {
      box.delete(productId);
    } else {
      _inMemoryFallback.remove(productId);
    }
  }

  @override
  void clear() {
    final box = _box;
    if (box != null && box.isOpen) {
      box.clear();
    } else {
      _inMemoryFallback.clear();
    }
  }
}

/// Backwards-compatible alias for existing references.
typedef WishlistLocalDatasource = WishlistLocalDataSourceImpl;
