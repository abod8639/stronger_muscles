import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import '../entities/checkout_params.dart';
import '../entities/checkout_result_entity.dart';
import '../repositories/checkout_repository.dart';

/// Pure Dart UseCase to submit an order and initiate payment if needed.
class PlaceOrderUseCase {
  const PlaceOrderUseCase(this._repository);

  final CheckoutRepository _repository;

  Future<Either<Failure, CheckoutResultEntity>> call(CheckoutParams params) {
    return _repository.placeOrder(params);
  }
}
