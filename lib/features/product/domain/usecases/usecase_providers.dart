import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/repositories/category_repository.dart';
import 'package:stronger_muscles/features/product/data/repositories/product_repository.dart';
import 'package:stronger_muscles/features/product/domain/usecases/get_all_categories_usecase.dart';
import 'package:stronger_muscles/features/product/domain/usecases/get_cached_categories_usecase.dart';
import 'package:stronger_muscles/features/product/domain/usecases/get_cached_products_usecase.dart';
import 'package:stronger_muscles/features/product/domain/usecases/get_product_by_id_usecase.dart';
import 'package:stronger_muscles/features/product/domain/usecases/get_products_usecase.dart';
import 'package:stronger_muscles/features/product/domain/usecases/search_products_usecase.dart';

part 'usecase_providers.g.dart';

@riverpod
GetProductsUseCase getProductsUseCase(GetProductsUseCaseRef ref) {
  return GetProductsUseCase(ref.watch(productRepositoryProvider));
}

@riverpod
GetCachedProductsUseCase getCachedProductsUseCase(GetCachedProductsUseCaseRef ref) {
  return GetCachedProductsUseCase(ref.watch(productRepositoryProvider));
}

@riverpod
GetProductByIdUseCase getProductByIdUseCase(GetProductByIdUseCaseRef ref) {
  return GetProductByIdUseCase(ref.watch(productRepositoryProvider));
}

@riverpod
SearchProductsUseCase searchProductsUseCase(SearchProductsUseCaseRef ref) {
  return SearchProductsUseCase(ref.watch(productRepositoryProvider));
}

@riverpod
GetAllCategoriesUseCase getAllCategoriesUseCase(GetAllCategoriesUseCaseRef ref) {
  return GetAllCategoriesUseCase(ref.watch(categoryRepositoryProvider));
}

@riverpod
GetCachedCategoriesUseCase getCachedCategoriesUseCase(GetCachedCategoriesUseCaseRef ref) {
  return GetCachedCategoriesUseCase(ref.watch(categoryRepositoryProvider));
}
