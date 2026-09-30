import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';

/// Use case to fetch all items currently in the cart.
class GetCartItemsUseCase {
  final CartRepository _repository;

  const GetCartItemsUseCase(this._repository);

  Future<List<CartItemEntity>> call() {
    return _repository.getCartItems();
  }
}
