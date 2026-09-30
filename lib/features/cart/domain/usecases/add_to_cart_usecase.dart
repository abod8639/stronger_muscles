import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Use case to add an item to the cart or increment its quantity.
class AddToCartUseCase {
  final CartRepository _repository;

  const AddToCartUseCase(this._repository);

  Future<void> call(
    ProductEntity product, {
    String? selectedFlavor,
    String? selectedSize,
    int quantity = 1,
  }) {
    return _repository.addToCart(
      product,
      selectedFlavor: selectedFlavor,
      selectedSize: selectedSize,
      quantity: quantity,
    );
  }
}
