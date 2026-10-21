import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';

/// Use case to clear all items from the cart returning [Either<Failure, Unit>].
class ClearCartUseCase {
  final CartRepository _repository;

  const ClearCartUseCase(this._repository);

  Future<Either<Failure, Unit>> call({CancelToken? cancelToken}) {
    return _repository.clearCart(cancelToken: cancelToken);
  }
}
