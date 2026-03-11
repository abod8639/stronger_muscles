import '../models/order_model.dart';

abstract class OrderLocalDatasource {
  Future<List<OrderModel>> getCachedOrders();
  Future<void> cacheOrders(List<OrderModel> models);
}

class OrderLocalDatasourceImpl implements OrderLocalDatasource {
  // TODO: inject SharedPreferences / Hive / Isar

  @override
  Future<List<OrderModel>> getCachedOrders() async {
    // TODO: implement local read
    throw UnimplementedError();
  }

  @override
  Future<void> cacheOrders(List<OrderModel> models) async {
    // TODO: implement local write
    throw UnimplementedError();
  }
}
