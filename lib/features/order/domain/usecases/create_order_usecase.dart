import 'package:stronger_muscles/features/order/domain/repositories/order_repository.dart';

/// Use case to submit and create a new order.
class CreateOrderUseCase {
  final OrderRepository _repository;

  const CreateOrderUseCase(this._repository);

  Future<Map<String, dynamic>> call(Map<String, dynamic> payload) {
    return _repository.createOrder(payload);
  }
}
