import 'package:get/get.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_remote_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_local_datasource.dart';
import 'package:stronger_muscles/features/product/data/models/category_model.dart';

class CategoryRepository {
  final CategoryRemoteDataSource _remote = Get.find<CategoryRemoteDataSource>();
  final CategoryLocalDataSource _local = CategoryLocalDataSource();

  List<CategoryModel> getCachedCategories() => _local.getCachedCategories();

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final categories = await _remote.fetchCategoriesFromApi();
      await _local.cacheCategories(categories);
      return categories;
    } catch (e) {
      if (_local.getCachedCategories().isNotEmpty) return _local.getCachedCategories();
      rethrow;
    }
  }
}