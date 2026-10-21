import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/domain/repositories/cart_repository.dart';

/// Use case to fetch all items currently in the cart returning [Either<Failure, List<CartItemEntity>>].
class GetCartItemsUseCase {
  final CartRepository _repository;

  const GetCartItemsUseCase(this._repository);

  Future<Either<Failure, List<CartItemEntity>>> call({CancelToken? cancelToken}) {
    return _repository.getCartItems(cancelToken: cancelToken);
  }
}
