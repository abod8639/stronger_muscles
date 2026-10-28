import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';

/// Pure Dart use case to update the quantity of a specific cart item.
class UpdateCartQuantityUseCase {
  final CartRepository _repository;

  const UpdateCartQuantityUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String itemId, int quantity) {
    return _repository.updateQuantity(itemId, quantity);
  }
}
