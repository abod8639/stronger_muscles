import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/order/data/models/order_model.dart';

abstract class OrderLocalDatasource {
  Future<List<OrderModel>> getCachedOrders();
  Future<void> cacheOrders(List<OrderModel> models);
  Future<OrderModel?> getCachedOrderById(String id);
  Future<void> clearCache();
}

class OrderLocalDatasourceImpl implements OrderLocalDatasource {
  final Box<OrderModel>? _boxInstance;

  OrderLocalDatasourceImpl([this._boxInstance]);

  Box<OrderModel> get _box {
    if (_boxInstance != null) return _boxInstance;
    if (Hive.isBoxOpen('orders')) {
      return Hive.box<OrderModel>('orders');
    }
    throw StateError("Orders Hive box is not open");
  }

  @override
  Future<List<OrderModel>> getCachedOrders() async {
    try {
      return _box.values.toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<OrderModel?> getCachedOrderById(String id) async {
    try {
      return _box.get(id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheOrders(List<OrderModel> models) async {
    try {
      final map = {for (var order in models) order.id: order};
      await _box.putAll(map);
    } catch (_) {
      // Graceful fallback
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _box.clear();
    } catch (_) {
      // Graceful fallback
    }
  }
}
