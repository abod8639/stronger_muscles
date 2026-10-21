import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Use case to add an item to the cart or increment its quantity returning [Either<Failure, Unit>].
class AddToCartUseCase {
  final CartRepository _repository;

  const AddToCartUseCase(this._repository);

  Future<Either<Failure, Unit>> call(
    ProductEntity product, {
    String? selectedFlavor,
    String? selectedSize,
    int quantity = 1,
    CancelToken? cancelToken,
  }) {
    return _repository.addToCart(
      product,
      selectedFlavor: selectedFlavor,
      selectedSize: selectedSize,
      quantity: quantity,
      cancelToken: cancelToken,
    );
  }
}
