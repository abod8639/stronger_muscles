import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/checkout/domain/entities/checkout_params.dart';
import 'package:stronger_muscles/features/checkout/domain/entities/checkout_result_entity.dart';

/// Domain contract for processing checkout orders and payments using the Either pattern.
abstract class CheckoutRepository {
  Future<Either<Failure, CheckoutResultEntity>> placeOrder(
    CheckoutParams params, {
    CancelToken? cancelToken,
  });
}
