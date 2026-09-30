import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';

/// Domain contract defining order operations.
abstract class OrderRepository {
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> payload);
  Future<List<OrderEntity>> getUserOrders({int? limit});
}
