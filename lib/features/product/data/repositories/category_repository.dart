import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_remote_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_local_datasource.dart';
import 'package:stronger_muscles/features/product/data/models/category_model.dart';
import 'package:stronger_muscles/core/services/api_service.dart';

part 'category_repository.g.dart';

@Riverpod(keepAlive: true)
CategoryRemoteDataSource categoryRemoteDataSource(CategoryRemoteDataSourceRef ref) {
  return CategoryRemoteDataSource(ref.watch(apiServiceProvider));
}

@Riverpod(keepAlive: true)
CategoryLocalDataSource categoryLocalDataSource(CategoryLocalDataSourceRef ref) {
  return CategoryLocalDataSource();
}

@Riverpod(keepAlive: true)
class CategoryRepository extends _$CategoryRepository {
  @override
  void build() {}

  List<CategoryModel> getCachedCategories() {
    return ref.read(categoryLocalDataSourceProvider).getCachedCategories();
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final remote = ref.read(categoryRemoteDataSourceProvider);
    final local = ref.read(categoryLocalDataSourceProvider);
    
    try {
      final categories = await remote.fetchCategoriesFromApi();
      await local.cacheCategories(categories);
      return categories;
    } catch (e) {
      if (local.getCachedCategories().isNotEmpty) {
        return local.getCachedCategories();
      }
      rethrow;
    }
  }
}
