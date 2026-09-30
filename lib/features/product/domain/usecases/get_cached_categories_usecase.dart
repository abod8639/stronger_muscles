import 'package:stronger_muscles/features/product/domain/entities/category_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/category_repository.dart';

/// Use case to retrieve locally cached categories synchronously.
class GetCachedCategoriesUseCase {
  final CategoryRepository _repository;

  const GetCachedCategoriesUseCase(this._repository);

  List<CategoryEntity> call() {
    return _repository.getCachedCategories();
  }
}
