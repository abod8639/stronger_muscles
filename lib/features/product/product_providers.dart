import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_local_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_remote_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_local_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_remote_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/review_remote_datasource.dart';
import 'package:stronger_muscles/features/product/data/repositories/category_repository_impl.dart';
import 'package:stronger_muscles/features/product/data/repositories/product_repository_impl.dart';
import 'package:stronger_muscles/features/product/data/repositories/review_repository_impl.dart';
import 'package:stronger_muscles/features/product/domain/repositories/category_repository.dart';
import 'package:stronger_muscles/features/product/domain/repositories/product_repository.dart';
import 'package:stronger_muscles/features/product/domain/repositories/review_repository.dart';
import 'package:stronger_muscles/features/product/domain/usecases/get_all_categories_usecase.dart';
import 'package:stronger_muscles/features/product/domain/usecases/get_cached_categories_usecase.dart';
import 'package:stronger_muscles/features/product/domain/usecases/get_cached_products_usecase.dart';
import 'package:stronger_muscles/features/product/domain/usecases/get_product_by_id_usecase.dart';
import 'package:stronger_muscles/features/product/domain/usecases/get_products_usecase.dart';
import 'package:stronger_muscles/features/product/domain/usecases/review_usecases.dart';
import 'package:stronger_muscles/features/product/domain/usecases/search_products_usecase.dart';

// ---------------------------------------------------------------------------
// Data Sources
// ---------------------------------------------------------------------------

final productLocalDataSourceProvider = Provider<ProductLocalDataSource>((ref) {
  return ProductLocalDataSource();
});

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSource(ref.watch(apiServiceProvider));
});

final categoryLocalDataSourceProvider = Provider<CategoryLocalDataSource>((ref) {
  return CategoryLocalDataSource();
});

final categoryRemoteDataSourceProvider = Provider<CategoryRemoteDataSource>((ref) {
  return CategoryRemoteDataSource(ref.watch(apiServiceProvider));
});

final reviewRemoteDataSourceProvider = Provider<ReviewRemoteDataSource>((ref) {
  return ReviewRemoteDataSource(ref.watch(apiServiceProvider));
});

// ---------------------------------------------------------------------------
// Repositories
// ---------------------------------------------------------------------------

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(
    ref.watch(productRemoteDataSourceProvider),
    ref.watch(productLocalDataSourceProvider),
  );
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(
    ref.watch(categoryRemoteDataSourceProvider),
    ref.watch(categoryLocalDataSourceProvider),
  );
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(
    ref.watch(reviewRemoteDataSourceProvider),
  );
});

// ---------------------------------------------------------------------------
// Use Cases
// ---------------------------------------------------------------------------

final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.watch(productRepositoryProvider));
});

final getProductByIdUseCaseProvider = Provider<GetProductByIdUseCase>((ref) {
  return GetProductByIdUseCase(ref.watch(productRepositoryProvider));
});

final searchProductsUseCaseProvider = Provider<SearchProductsUseCase>((ref) {
  return SearchProductsUseCase(ref.watch(productRepositoryProvider));
});

final getCachedProductsUseCaseProvider = Provider<GetCachedProductsUseCase>((ref) {
  return GetCachedProductsUseCase(ref.watch(productRepositoryProvider));
});

final getAllCategoriesUseCaseProvider = Provider<GetAllCategoriesUseCase>((ref) {
  return GetAllCategoriesUseCase(ref.watch(categoryRepositoryProvider));
});

final getCachedCategoriesUseCaseProvider = Provider<GetCachedCategoriesUseCase>((ref) {
  return GetCachedCategoriesUseCase(ref.watch(categoryRepositoryProvider));
});

final getProductReviewsUseCaseProvider = Provider<GetProductReviewsUseCase>((ref) {
  return GetProductReviewsUseCase(ref.watch(reviewRepositoryProvider));
});

final getUserProductReviewUseCaseProvider = Provider<GetUserProductReviewUseCase>((ref) {
  return GetUserProductReviewUseCase(ref.watch(reviewRepositoryProvider));
});

final submitReviewUseCaseProvider = Provider<SubmitReviewUseCase>((ref) {
  return SubmitReviewUseCase(ref.watch(reviewRepositoryProvider));
});

final deleteReviewUseCaseProvider = Provider<DeleteReviewUseCase>((ref) {
  return DeleteReviewUseCase(ref.watch(reviewRepositoryProvider));
});
