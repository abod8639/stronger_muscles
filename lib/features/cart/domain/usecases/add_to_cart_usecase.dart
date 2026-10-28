import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Pure Dart use case to add a product to the cart with specified options.
class AddToCartUseCase {
  final CartRepository _repository;

  const AddToCartUseCase(this._repository);

  Future<Either<Failure, Unit>> call(
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
