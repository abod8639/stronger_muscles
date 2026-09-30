import 'package:stronger_muscles/features/product/domain/entities/category_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/category_repository.dart';

/// Use case to fetch all categories from repository.
class GetAllCategoriesUseCase {
  final CategoryRepository _repository;

  const GetAllCategoriesUseCase(this._repository);

  Future<List<CategoryEntity>> call() {
    return _repository.getAllCategories();
  }
}
