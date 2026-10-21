import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/home/domain/repositories/home_repository.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Use case to fetch products for home view returning [Either<Failure, List<ProductEntity>>].
class GetHomeProductsUseCase {
  final HomeRepository _repository;

  const GetHomeProductsUseCase(this._repository);

  Future<Either<Failure, List<ProductEntity>>> call({
    String? categoryId,
    int page = 1,
    CancelToken? cancelToken,
  }) {
    return _repository.getHomeProducts(
      categoryId: categoryId,
      page: page,
      cancelToken: cancelToken,
    );
  }
}
