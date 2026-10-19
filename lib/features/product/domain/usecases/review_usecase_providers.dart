import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/product/data/repositories/review_repository_impl.dart';
import 'package:stronger_muscles/features/product/domain/usecases/review_usecases.dart';

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
