import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_remote_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_local_datasource.dart';
import 'package:stronger_muscles/features/product/data/models/category_model.dart';
import 'package:stronger_muscles/core/services/api_service.dart';

part 'category_repository.g.dart';

@Riverpod(keepAlive: true)
CategoryRemoteDataSource categoryRemoteDataSource(
  CategoryRemoteDataSourceRef ref,
) {
  return CategoryRemoteDataSource(ref.watch(apiServiceProvider));
}

@Riverpod(keepAlive: true)
CategoryLocalDataSource categoryLocalDataSource(
  CategoryLocalDataSourceRef ref,
) {
  return CategoryLocalDataSource();
}

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(CategoryRepositoryRef ref) {
  return CategoryRepository(
    ref.watch(categoryRemoteDataSourceProvider),
    ref.watch(categoryLocalDataSourceProvider),
  );
}

class CategoryRepository {
  final CategoryRemoteDataSource _remote;
  final CategoryLocalDataSource _local;

  CategoryRepository(this._remote, this._local);

  List<CategoryModel> getCachedCategories() {
    return _local.getCachedCategories();
  }

  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final categories = await _remote.fetchCategoriesFromApi();
      await _local.cacheCategories(categories);
      return categories;
    } catch (e) {
      if (_local.getCachedCategories().isNotEmpty) {
        return _local.getCachedCategories();
      }
      rethrow;
    }
  }
}
