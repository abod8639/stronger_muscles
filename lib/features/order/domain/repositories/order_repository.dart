import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<List<OrderEntity>> getAllOrders();
  Future<OrderEntity> getOrderById(String id);
  Future<void> createOrder(OrderEntity entity);
}
