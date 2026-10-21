import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';

/// Use case to update the quantity of a cart item returning [Either<Failure, Unit>].
class UpdateCartQuantityUseCase {
  final CartRepository _repository;

  const UpdateCartQuantityUseCase(this._repository);

  Future<Either<Failure, Unit>> call(
    String itemId,
    int quantity, {
    CancelToken? cancelToken,
  }) {
    return _repository.updateQuantity(
      itemId,
      quantity,
      cancelToken: cancelToken,
    );
  }
}
