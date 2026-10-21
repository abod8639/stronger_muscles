import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';

/// Use case to remove an item from the cart returning [Either<Failure, Unit>].
class RemoveFromCartUseCase {
  final CartRepository _repository;

  const RemoveFromCartUseCase(this._repository);

  Future<Either<Failure, Unit>> call(
    String itemId, {
    CancelToken? cancelToken,
  }) {
    return _repository.removeFromCart(itemId, cancelToken: cancelToken);
  }
}
