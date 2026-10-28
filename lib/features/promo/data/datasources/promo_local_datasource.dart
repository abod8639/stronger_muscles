import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/promo/data/models/promo_model.dart';

/// Local data source contract for caching promotional banners.
abstract class PromoLocalDataSource {
  List<PromoModel> getCachedPromos();
  Future<void> cachePromos(List<PromoModel> promos);
  Future<void> clearCache();
}

/// Local data source implementation using Hive with in-memory fallback.
class PromoLocalDataSourceImpl implements PromoLocalDataSource {
  static const String boxName = 'promos';
  Box<PromoModel>? _box;
  final Map<int, PromoModel> _inMemoryFallback = {};
  bool _hiveFailed = false;

  PromoLocalDataSourceImpl([this._box]);

  Box<PromoModel>? _getBoxSafe() {
    if (_box != null && _box!.isOpen) return _box;
    if (_hiveFailed) return null;
    try {
      if (Hive.isBoxOpen(boxName)) {
        _box = Hive.box<PromoModel>(boxName);
        return _box;
      }
      return null;
    } catch (e) {
      _hiveFailed = true;
      debugPrint('[PromoLocalDataSource] Hive fallback active: $e');
      return null;
    }
  }

  @override
  List<PromoModel> getCachedPromos() {
    try {
      final box = _getBoxSafe();
      if (box != null && box.isOpen) {
        return box.values.toList();
      }
      return _inMemoryFallback.values.toList();
    } catch (e) {
      debugPrint('[PromoLocalDataSource] Error getting cached promos: $e');
      return _inMemoryFallback.values.toList();
    }
  }

  @override
  Future<void> cachePromos(List<PromoModel> promos) async {
    try {
      final box = _getBoxSafe();
      if (box != null && box.isOpen) {
        await box.clear();
        await box.addAll(promos);
      }
      _inMemoryFallback.clear();
      for (final promo in promos) {
        _inMemoryFallback[promo.id] = promo;
      }
    } catch (e) {
      debugPrint('[PromoLocalDataSource] Error caching promos: $e');
      _inMemoryFallback.clear();
      for (final promo in promos) {
        _inMemoryFallback[promo.id] = promo;
      }
    }
  }

  @override
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
