import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/product_details/data/datasources/product_details_local_datasource.dart';
import 'package:stronger_muscles/features/product_details/data/datasources/product_details_remote_datasource.dart';
import 'package:stronger_muscles/features/product_details/data/repositories/product_details_repository_impl.dart';
import 'package:stronger_muscles/features/product_details/domain/repositories/product_details_repository.dart';
import 'package:stronger_muscles/features/product_details/domain/usecases/delete_product_review_usecase.dart';
import 'package:stronger_muscles/features/product_details/domain/usecases/get_product_details_usecase.dart';
import 'package:stronger_muscles/features/product_details/domain/usecases/get_product_reviews_usecase.dart';
import 'package:stronger_muscles/features/product_details/domain/usecases/get_user_product_review_usecase.dart';
import 'package:stronger_muscles/features/product_details/domain/usecases/submit_product_review_usecase.dart';

// ---------------------------------------------------------------------------
// Data Sources
// ---------------------------------------------------------------------------

final productDetailsLocalDataSourceProvider =
    Provider<ProductDetailsLocalDataSource>((ref) {
  return ProductDetailsLocalDataSource();
});

final productDetailsRemoteDataSourceProvider =
    Provider<ProductDetailsRemoteDataSource>((ref) {
  return ProductDetailsRemoteDataSource(ref.watch(apiServiceProvider));
});

// ---------------------------------------------------------------------------
// Repository
// ---------------------------------------------------------------------------

final productDetailsRepositoryProvider =
    Provider<ProductDetailsRepository>((ref) {
  return ProductDetailsRepositoryImpl(
    ref.watch(productDetailsRemoteDataSourceProvider),
    ref.watch(productDetailsLocalDataSourceProvider),
  );
});

// ---------------------------------------------------------------------------
// Use Cases
// ---------------------------------------------------------------------------

final getProductDetailsUseCaseProvider =
    Provider<GetProductDetailsUseCase>((ref) {
  return GetProductDetailsUseCase(ref.watch(productDetailsRepositoryProvider));
});

final getProductReviewsUseCaseProvider =
    Provider<GetProductReviewsUseCase>((ref) {
  return GetProductReviewsUseCase(ref.watch(productDetailsRepositoryProvider));
});

final getUserProductReviewUseCaseProvider =
    Provider<GetUserProductReviewUseCase>((ref) {
  return GetUserProductReviewUseCase(ref.watch(productDetailsRepositoryProvider));
});

final submitProductReviewUseCaseProvider =
    Provider<SubmitProductReviewUseCase>((ref) {
  return SubmitProductReviewUseCase(ref.watch(productDetailsRepositoryProvider));
});

final deleteProductReviewUseCaseProvider =
    Provider<DeleteProductReviewUseCase>((ref) {
  return DeleteProductReviewUseCase(ref.watch(productDetailsRepositoryProvider));
});
