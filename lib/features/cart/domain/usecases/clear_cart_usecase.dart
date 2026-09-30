import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';

/// Use case to remove all items from the cart.
class ClearCartUseCase {
  final CartRepository _repository;

  const ClearCartUseCase(this._repository);

  Future<void> call() {
    return _repository.clearCart();
  }
}
