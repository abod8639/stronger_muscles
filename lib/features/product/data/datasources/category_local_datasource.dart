import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/product/data/models/category_model.dart';

/// Local data source for caching product categories using Hive with in-memory fallback.
class CategoryLocalDataSource {
  static const String boxName = 'categories';
  Box<CategoryModel>? _box;
  final Map<String, CategoryModel> _inMemoryFallback = {};
  bool _hiveFailed = false;

  CategoryLocalDataSource([this._box]);

  Box<CategoryModel>? _getBoxSafe() {
    if (_box != null && _box!.isOpen) return _box;
    if (_hiveFailed) return null;
    try {
      if (Hive.isBoxOpen(boxName)) {
        _box = Hive.box<CategoryModel>(boxName);
        return _box;
      }
      return null;
    } catch (e) {
      _hiveFailed = true;
      debugPrint('[CategoryLocalDataSource] Hive fallback active: $e');
      return null;
    }
  }

  List<CategoryModel> getCachedCategories() {
    try {
      final box = _getBoxSafe();
      if (box != null && box.isOpen) {
        return box.values.toList();
      }
      return _inMemoryFallback.values.toList();
    } catch (e) {
      debugPrint('[CategoryLocalDataSource] Error getting cached categories: $e');
      return _inMemoryFallback.values.toList();
    }
  }

  Future<void> cacheCategories(List<CategoryModel> categories) async {
    try {
      final box = _getBoxSafe();
      if (box != null && box.isOpen) {
        await box.clear();
        await box.addAll(categories);
      }
      _inMemoryFallback.clear();
      for (final cat in categories) {
        _inMemoryFallback[cat.id] = cat;
      }
    } catch (e) {
      debugPrint('[CategoryLocalDataSource] Error caching categories: $e');
      _inMemoryFallback.clear();
      for (final cat in categories) {
        _inMemoryFallback[cat.id] = cat;
      }
    }
  }

  Future<void> clearCache() async {
    try {
      final box = _getBoxSafe();
      if (box != null && box.isOpen) {
        await box.clear();
      }
      _inMemoryFallback.clear();
    } catch (e) {
      _inMemoryFallback.clear();
    }
  }
}
