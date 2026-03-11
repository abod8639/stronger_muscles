import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetOrdersUsecase {
  final OrderRepository repository;

  GetOrdersUsecase(this.repository);

  Future<List<OrderEntity>> call() => repository.getAllOrders();
}
