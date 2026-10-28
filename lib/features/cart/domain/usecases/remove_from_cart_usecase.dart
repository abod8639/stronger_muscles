import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';

/// Pure Dart use case to remove an item from the cart by its ID.
class RemoveFromCartUseCase {
  final CartRepository _repository;

  const RemoveFromCartUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String itemId) {
    return _repository.removeFromCart(itemId);
  }
}
