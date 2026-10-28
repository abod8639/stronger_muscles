import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/order/domain/repositories/order_repository.dart';

/// Pure domain use case to submit and create a new order.
class CreateOrderUseCase {
  final OrderRepository _repository;

  const CreateOrderUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> call(
    Map<String, dynamic> payload,
  ) {
    return _repository.createOrder(payload);
  }
}
