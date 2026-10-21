import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/home/domain/entities/selection_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Domain repository contract defining home screen operations.
/// Follows Result/Either pattern via fpdart with typed [Failure] integration.
abstract class HomeRepository {
  /// Fetches category shortcuts for the home screen header.
  Future<Either<Failure, List<SelectionEntity>>> getHomeShortcuts({
    required String langCode,
    CancelToken? cancelToken,
  });

  /// Fetches products displayed on the home screen with optional category filter and pagination.
  Future<Either<Failure, List<ProductEntity>>> getHomeProducts({
    String? categoryId,
    int page = 1,
    CancelToken? cancelToken,
  });
}
