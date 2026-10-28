import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/order/data/models/order_model.dart';

/// Local data source contract for caching orders in Hive.
abstract class OrderLocalDatasource {
  Future<List<OrderModel>> getCachedOrders();
  Future<void> cacheOrders(List<OrderModel> models);
  Future<OrderModel?> getCachedOrderById(String id);
  Future<void> updateCachedOrder(OrderModel model);
  Future<void> clearCache();
}

/// Concrete Hive implementation of [OrderLocalDatasource] with in-memory fallback.
class OrderLocalDatasourceImpl implements OrderLocalDatasource {
  static const String boxName = 'orders';

  Box<OrderModel>? _boxInstance;
  final Map<String, OrderModel> _inMemoryFallback = {};
  bool _hiveFailed = false;

  OrderLocalDatasourceImpl([this._boxInstance]);

  Future<Box<OrderModel>?> _getBoxSafe() async {
    if (_boxInstance != null && _boxInstance!.isOpen) return _boxInstance;
    if (_hiveFailed) return null;
    try {
      if (Hive.isBoxOpen(boxName)) {
        _boxInstance = Hive.box<OrderModel>(boxName);
      } else {
        _boxInstance = await Hive.openBox<OrderModel>(boxName);
      }
      return _boxInstance;
    } catch (e) {
      _hiveFailed = true;
      debugPrint('[OrderLocalDatasource] Hive fallback active: $e');
      return null;
    }
  }

  @override
  Future<List<OrderModel>> getCachedOrders() async {
    try {
      final box = await _getBoxSafe();
      if (box != null) {
        return box.values.toList();
      }
      return _inMemoryFallback.values.toList();
    } catch (e) {
      debugPrint('[OrderLocalDatasource] Error reading cached orders: $e');
      return _inMemoryFallback.values.toList();
    }
  }

  @override
  Future<OrderModel?> getCachedOrderById(String id) async {
    try {
      final box = await _getBoxSafe();
      if (box != null) {
        return box.get(id);
      }
      return _inMemoryFallback[id];
    } catch (e) {
      debugPrint('[OrderLocalDatasource] Error reading cached order: $e');
      return _inMemoryFallback[id];
    }
  }

  @override
  Future<void> cacheOrders(List<OrderModel> models) async {
    try {
      final map = {for (final order in models) order.id: order};
      final box = await _getBoxSafe();
      if (box != null) {
        await box.putAll(map);
      }
      _inMemoryFallback.addAll(map);
    } catch (e) {
      debugPrint('[OrderLocalDatasource] Error caching orders: $e');
      for (final order in models) {
        _inMemoryFallback[order.id] = order;
      }
    }
  }

  @override
  Future<void> updateCachedOrder(OrderModel model) async {
    try {
      final box = await _getBoxSafe();
      if (box != null) {
        await box.put(model.id, model);
      }
      _inMemoryFallback[model.id] = model;
    } catch (e) {
      debugPrint('[OrderLocalDatasource] Error updating cached order: $e');
      _inMemoryFallback[model.id] = model;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await _getBoxSafe();
      if (box != null) {
        await box.clear();
      }
      _inMemoryFallback.clear();
    } catch (e) {
      debugPrint('[OrderLocalDatasource] Error clearing orders cache: $e');
      _inMemoryFallback.clear();
    }
  }
}
