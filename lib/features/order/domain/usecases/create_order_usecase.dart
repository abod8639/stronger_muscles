import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class CreateOrderUsecase {
  final OrderRepository repository;

  CreateOrderUsecase(this.repository);

  Future<void> call(OrderEntity entity) => repository.createOrder(entity);
}
