import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';

/// Use case to completely remove an item from the cart.
class RemoveFromCartUseCase {
  final CartRepository _repository;

  const RemoveFromCartUseCase(this._repository);

  Future<void> call(String itemId) {
    return _repository.removeFromCart(itemId);
  }
}
