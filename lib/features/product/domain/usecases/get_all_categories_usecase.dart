import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/domain/entities/category_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/category_repository.dart';

/// Pure Dart UseCase to fetch all categories from the repository.
class GetAllCategoriesUseCase {
  final CategoryRepository _repository;

  const GetAllCategoriesUseCase(this._repository);

  Future<Either<Failure, List<CategoryEntity>>> call() {
    return _repository.getAllCategories();
  }
}
