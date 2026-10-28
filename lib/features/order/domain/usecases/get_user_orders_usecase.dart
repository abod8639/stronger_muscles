import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/domain/repositories/order_repository.dart';

/// Pure domain use case to fetch orders belonging to the authenticated user.
class GetUserOrdersUseCase {
  final OrderRepository _repository;

  const GetUserOrdersUseCase(this._repository);

  Future<Either<Failure, List<OrderEntity>>> call({
    int page = 1,
    int? limit,
  }) {
    return _repository.getUserOrders(page: page, limit: limit);
  }
}
