import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/order/domain/repositories/order_repository.dart';

/// Pure domain use case to cancel an order by its identifier.
class CancelOrderUseCase {
  final OrderRepository _repository;

  const CancelOrderUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String id) {
    return _repository.cancelOrder(id);
  }
}
