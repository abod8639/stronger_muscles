import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/domain/entities/category_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/category_repository.dart';

/// Pure Dart UseCase to retrieve locally cached categories synchronously.
class GetCachedCategoriesUseCase {
  final CategoryRepository _repository;

  const GetCachedCategoriesUseCase(this._repository);

  Either<Failure, List<CategoryEntity>> call() {
    return _repository.getCachedCategories();
  }
}
