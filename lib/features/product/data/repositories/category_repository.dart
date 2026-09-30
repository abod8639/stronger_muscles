import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_local_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_remote_datasource.dart';
import 'package:stronger_muscles/features/product/domain/entities/category_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/category_repository.dart';

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
  return CategoryRepositoryImpl(
    ref.watch(categoryRemoteDataSourceProvider),
    ref.watch(categoryLocalDataSourceProvider),
  );
}

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remote;
  final CategoryLocalDataSource _local;

  CategoryRepositoryImpl(this._remote, this._local);

  @override
  List<CategoryEntity> getCachedCategories() {
    return _local.getCachedCategories().map((c) => c.toEntity()).toList();
  }

  @override
  Future<List<CategoryEntity>> getAllCategories() async {
    try {
      final categories = await _remote.fetchCategoriesFromApi();
      await _local.cacheCategories(categories);
      return categories.map((c) => c.toEntity()).toList();
    } catch (e) {
      if (_local.getCachedCategories().isNotEmpty) {
        return _local.getCachedCategories().map((c) => c.toEntity()).toList();
      }
      rethrow;
    }
  }
}
