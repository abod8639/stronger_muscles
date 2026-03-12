import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_service.dart';
import 'package:stronger_muscles/features/product/data/models/category_model.dart';

class CategoryRepository {
  final CategoryService _service = Get.put(CategoryService());
  final Box<CategoryModel> _box = Hive.box<CategoryModel>('categories');

  List<CategoryModel> getCachedCategories() => _box.values.toList();

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final categories = await _service.fetchCategoriesFromApi();

      await _box.clear();
      await _box.addAll(categories);

      return categories;
    } on Failure catch (e) {
      if (e.type == FailureType.network && _box.isNotEmpty) {
        return _box.values.toList();
      }
      rethrow;
    }
  }
}
