import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/domain/repositories/order_repository.dart';

/// Use case to fetch orders belonging to the authenticated user.
class GetUserOrdersUseCase {
  final OrderRepository _repository;

  const GetUserOrdersUseCase(this._repository);

  Future<List<OrderEntity>> call({int? limit}) {
    return _repository.getUserOrders(limit: limit);
  }
}
