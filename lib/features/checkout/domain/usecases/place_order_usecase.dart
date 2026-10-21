import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/checkout/domain/entities/checkout_params.dart';
import 'package:stronger_muscles/features/checkout/domain/entities/checkout_result_entity.dart';
import 'package:stronger_muscles/features/checkout/domain/repositories/checkout_repository.dart';

/// Use case to submit an order and initiate payment if needed with Either error handling.
class PlaceOrderUseCase {
  final CheckoutRepository _repository;

  const PlaceOrderUseCase(this._repository);

  Future<Either<Failure, CheckoutResultEntity>> call(
    CheckoutParams params, {
    CancelToken? cancelToken,
  }) {
    return _repository.placeOrder(params, cancelToken: cancelToken);
  }
}
