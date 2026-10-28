import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/home/data/models/selection_model.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';

/// Local data source contract for Home feature caching.
abstract class HomeLocalDataSource {
  Future<List<SelectionsModel>> getCachedShortcuts();
  Future<void> cacheShortcuts(List<SelectionsModel> shortcuts);

  Future<List<ProductModel>> getCachedProducts({String? categoryId});
  Future<void> cacheProducts(List<ProductModel> products);

  List<SelectionsModel> getDefaultShortcuts(String langCode);
  Future<void> clearCache();
}

/// Concrete Hive implementation of [HomeLocalDataSource] with robust in-memory fallback.
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  static const String boxName = 'home_box';
  static const String _shortcutsKey = 'cached_shortcuts';
  static const String _productsKey = 'cached_products';

  Box? _box;
  final Map<String, dynamic> _inMemoryFallback = {};
  bool _hiveFailed = false;

  HomeLocalDataSourceImpl([Box? box]) : _box = box;

  Future<Box?> _getBoxSafe() async {
    if (_box != null && _box!.isOpen) return _box;
    if (_hiveFailed) return null;
    try {
      if (Hive.isBoxOpen(boxName)) {
        _box = Hive.box(boxName);
      } else {
        _box = await Hive.openBox(boxName);
      }
      return _box;
    } catch (e) {
      _hiveFailed = true;
      debugPrint('[HomeLocalDataSource] Hive storage fallback active: $e');
      return null;
    }
  }

  @override
  Future<List<SelectionsModel>> getCachedShortcuts() async {
    try {
      final box = await _getBoxSafe();
      dynamic raw;
      if (box != null) {
        raw = box.get(_shortcutsKey);
      } else {
        raw = _inMemoryFallback[_shortcutsKey];
      }

      if (raw is List) {
        return raw.map((item) {
          if (item is SelectionsModel) return item;
          if (item is Map) return SelectionsModel.fromJson(Map<String, dynamic>.from(item));
          return SelectionsModel.fromJson(item);
        }).toList();
      }
      return const [];
    } catch (e) {
      debugPrint('[HomeLocalDataSource] Error getting cached shortcuts: $e');
      return const [];
    }
  }

  @override
  Future<void> cacheShortcuts(List<SelectionsModel> shortcuts) async {
    try {
      final serialized = shortcuts.map((s) => s.toJson()).toList();
      final box = await _getBoxSafe();
      if (box != null) {
        await box.put(_shortcutsKey, serialized);
      }
      _inMemoryFallback[_shortcutsKey] = serialized;
    } catch (e) {
      debugPrint('[HomeLocalDataSource] Error caching shortcuts: $e');
      _inMemoryFallback[_shortcutsKey] = shortcuts.map((s) => s.toJson()).toList();
    }
  }

  @override
  Future<List<ProductModel>> getCachedProducts({String? categoryId}) async {
    try {
      final box = await _getBoxSafe();
      dynamic raw;
      if (box != null) {
        raw = box.get(_productsKey);
      } else {
        raw = _inMemoryFallback[_productsKey];
      }

      if (raw is List) {
        final products = <ProductModel>[];
        for (final item in raw) {
          if (item is ProductModel) {
            products.add(item);
          } else if (item is Map) {
            try {
              products.add(ProductModel.fromJson(Map<String, dynamic>.from(item)));
            } catch (_) {}
          }
        }

        if (categoryId != null && categoryId.isNotEmpty) {
          return products.where((p) => p.categoryId == categoryId).toList();
        }
        return products;
      }
      return const [];
    } catch (e) {
      debugPrint('[HomeLocalDataSource] Error getting cached products: $e');
      return const [];
    }
  }

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final serialized = products.map((p) => p.toJson()).toList();
      final box = await _getBoxSafe();
      if (box != null) {
        await box.put(_productsKey, serialized);
      }
      _inMemoryFallback[_productsKey] = serialized;
    } catch (e) {
      debugPrint('[HomeLocalDataSource] Error caching products: $e');
      _inMemoryFallback[_productsKey] = products.map((p) => p.toJson()).toList();
    }
  }

  @override
  List<SelectionsModel> getDefaultShortcuts(String langCode) {
    return const [
      SelectionsModel(id: '', label: 'categoryHome', iconKey: 'home'),
      SelectionsModel(id: 'protein', label: 'categoryProtein', iconKey: 'protein'),
      SelectionsModel(id: 'creatine', label: 'categoryCreatine', iconKey: 'creatine'),
      SelectionsModel(id: 'amino', label: 'categoryAmino', iconKey: 'amino'),
      SelectionsModel(id: 'bcaa', label: 'categoryBcaa', iconKey: 'bcaa'),
      SelectionsModel(id: 'preworkout', label: 'categoryPreWorkout', iconKey: 'preworkout'),
      SelectionsModel(id: 'massgainer', label: 'categoryMassGainer', iconKey: 'massgainer'),
      SelectionsModel(id: 'vitamins', label: 'categoryVitamins', iconKey: 'vitamins'),
      SelectionsModel(id: 'accessories', label: 'categoryAccessories', iconKey: 'accessories'),
    ];
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await _getBoxSafe();
      if (box != null) {
        await box.delete(_shortcutsKey);
        await box.delete(_productsKey);
      }
      _inMemoryFallback.clear();
    } catch (e) {
      debugPrint('[HomeLocalDataSource] Error clearing cache: $e');
      _inMemoryFallback.clear();
    }
  }
}
