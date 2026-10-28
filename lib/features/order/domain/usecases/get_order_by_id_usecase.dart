import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/domain/repositories/order_repository.dart';

/// Pure domain use case to fetch a single order by its identifier.
class GetOrderByIdUseCase {
  final OrderRepository _repository;

  const GetOrderByIdUseCase(this._repository);

  Future<Either<Failure, OrderEntity?>> call(String id) {
    return _repository.getOrderById(id);
  }
}
