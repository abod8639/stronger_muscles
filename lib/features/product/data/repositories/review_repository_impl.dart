import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/product/data/datasources/review_remote_datasource.dart';
import 'package:stronger_muscles/features/product/domain/entities/review_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/review_repository.dart';

final reviewRemoteDataSourceProvider = Provider<ReviewRemoteDataSource>((ref) {
  return ReviewRemoteDataSource(ref.watch(apiServiceProvider));
});

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepositoryImpl(ref.watch(reviewRemoteDataSourceProvider));
});

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource _remoteDataSource;

  ReviewRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<ReviewEntity>> getProductReviews(String productId, {int page = 1}) async {
    final models = await _remoteDataSource.getProductReviews(productId, page: page);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ReviewEntity?> getUserProductReview(String productId) async {
    final model = await _remoteDataSource.getUserProductReview(productId);
    return model?.toEntity();
  }

  @override
  Future<ReviewEntity> submitReview({
    required String productId,
    required double rating,
    required String comment,
  }) async {
    final model = await _remoteDataSource.submitReview(
      productId: productId,
      rating: rating,
      comment: comment,
    );
    return model.toEntity();
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    await _remoteDataSource.deleteReview(reviewId);
  }
}
