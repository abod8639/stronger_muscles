import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/product/domain/entities/category_entity.dart';
import 'package:stronger_muscles/features/product/product_providers.dart';

/// AsyncNotifier managing category list state with caching fallback.
class CategoryController extends AutoDisposeAsyncNotifier<List<CategoryEntity>> {
  @override
  FutureOr<List<CategoryEntity>> build() async {
    final cachedResult = ref.watch(getCachedCategoriesUseCaseProvider)();
    final cached = cachedResult.getOrElse((_) => []);
    if (cached.isNotEmpty) {
      return cached;
    }

    final result = await ref.watch(getAllCategoriesUseCaseProvider)();
    return result.fold(
      (failure) => throw failure,
      (categories) => categories,
    );
  }

  Future<void> fetchCategories() async {
    state = const AsyncLoading();
    final result = await ref.read(getAllCategoriesUseCaseProvider)();
    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      (categories) => AsyncData(categories),
    );
  }
}

/// Global provider for [CategoryController].
final categoryControllerProvider =
    AutoDisposeAsyncNotifierProvider<CategoryController, List<CategoryEntity>>(
  CategoryController.new,
);
