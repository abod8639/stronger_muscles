import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/domain/entities/category_entity.dart';
import 'package:stronger_muscles/features/product/domain/usecases/usecase_providers.dart';

part 'category_controller.g.dart';

@riverpod
class CategoryController extends _$CategoryController {
  @override
  FutureOr<List<CategoryEntity>> build() async {
    final cached = ref.watch(getCachedCategoriesUseCaseProvider)();

    if (cached.isNotEmpty) {
      return cached;
    }

    return await ref.watch(getAllCategoriesUseCaseProvider)();
  }

  Future<void> fetchCategories() async {
    try {
      final result = await ref.read(getAllCategoriesUseCaseProvider)();
      state = AsyncData(result);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
