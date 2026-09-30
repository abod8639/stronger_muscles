import 'package:stronger_muscles/features/product/domain/entities/category_entity.dart';

/// Domain contract defining category operations.
abstract class CategoryRepository {
  List<CategoryEntity> getCachedCategories();
  Future<List<CategoryEntity>> getAllCategories();
}
