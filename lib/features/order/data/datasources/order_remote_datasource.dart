import '../models/order_model.dart';

abstract class OrderRemoteDatasource {
  Future<List<OrderModel>> getAllOrders();
  Future<OrderModel> getOrderById(String id);
  Future<void> createOrder(OrderModel model);
}

class OrderRemoteDatasourceImpl implements OrderRemoteDatasource {
  // TODO: inject Dio / http client

  @override
  Future<List<OrderModel>> getAllOrders() async {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> createOrder(OrderModel model) async {
    // TODO: implement API call
    throw UnimplementedError();
  }
}
