import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetOrderByIdUsecase {
  final OrderRepository repository;

  GetOrderByIdUsecase(this.repository);

  Future<OrderEntity> call(String id) => repository.getOrderById(id);
}
