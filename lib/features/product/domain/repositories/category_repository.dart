import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/domain/entities/category_entity.dart';

/// Pure domain repository contract defining category operations with functional error handling.
abstract class CategoryRepository {
  /// Returns cached categories synchronously if available.
  Either<Failure, List<CategoryEntity>> getCachedCategories();

  /// Fetches all categories from remote API (with offline caching fallback).
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories();
}
