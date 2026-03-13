import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/models/category_model.dart';
import 'package:stronger_muscles/features/product/data/repositories/category_repository.dart';

part 'category_controller.g.dart';

@riverpod
class CategoryController extends _$CategoryController {
  @override
  FutureOr<List<CategoryModel>> build() async {
    final repository = ref.watch(categoryRepositoryProvider.notifier);
    final cached = repository.getCachedCategories();
    
    if (cached.isNotEmpty) {
      _initFetch();
      return cached;
    }
    
    return await repository.getAllCategories();
  }

  Future<void> _initFetch() async {
    await fetchCategories();
  }

  Future<void> fetchCategories() async {
    final repository = ref.read(categoryRepositoryProvider.notifier);
    try {
      final result = await repository.getAllCategories();
      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
