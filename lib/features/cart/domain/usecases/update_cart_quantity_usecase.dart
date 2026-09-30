import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';

/// Use case to update the quantity of a specific cart item.
class UpdateCartQuantityUseCase {
  final CartRepository _repository;

  const UpdateCartQuantityUseCase(this._repository);

  Future<void> call(String itemId, int quantity) {
    return _repository.updateQuantity(itemId, quantity);
  }
}
