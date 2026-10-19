import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/product/data/datasources/review_remote_datasource.dart';
import 'package:stronger_muscles/features/product/data/models/review_model.dart';
import 'package:stronger_muscles/features/product/data/repositories/review_repository_impl.dart';
import 'package:stronger_muscles/features/product/domain/repositories/review_repository.dart';
import 'package:stronger_muscles/features/product/domain/usecases/review_usecases.dart';

class FakeReviewRemoteDataSource implements ReviewRemoteDataSource {
  final List<ReviewModel> reviews = [];
  ReviewModel? userReview;

  @override
  Future<List<ReviewModel>> getProductReviews(String productId, {int page = 1}) async {
    return reviews.where((r) => r.productId == productId).toList();
  }

  @override
  Future<ReviewModel?> getUserProductReview(String productId) async {
    return userReview;
  }

  @override
  Future<ReviewModel> submitReview({
    required String productId,
    required double rating,
    required String comment,
  }) async {
    final model = ReviewModel(
      id: 'rev-test-1',
      productId: productId,
      userId: 'user-1',
      userName: 'Test User',
      rating: rating,
      comment: comment,
      isVerifiedPurchase: true,
      createdAt: DateTime.now(),
    );
    reviews.add(model);
    userReview = model;
    return model;
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    reviews.removeWhere((r) => r.id == reviewId);
    if (userReview?.id == reviewId) {
      userReview = null;
    }
  }
}

void main() {
  group('Review Feature Tests', () {
    late FakeReviewRemoteDataSource fakeRemoteDataSource;
    late ReviewRepository repository;

    final sampleModel = ReviewModel(
      id: 'rev-1',
      productId: 'prod-100',
      userId: 'user-100',
      userName: 'Ahmed',
      rating: 4.8,
      comment: 'Excellent flavor and results!',
      isVerifiedPurchase: true,
      createdAt: DateTime.parse('2026-01-01T10:00:00Z'),
    );

    setUp(() {
      fakeRemoteDataSource = FakeReviewRemoteDataSource();
      repository = ReviewRepositoryImpl(fakeRemoteDataSource);
      fakeRemoteDataSource.reviews.add(sampleModel);
    });

    test('ReviewModel toEntity and fromEntity convert correctly', () {
      final entity = sampleModel.toEntity();
      expect(entity.id, 'rev-1');
      expect(entity.userName, 'Ahmed');
      expect(entity.rating, 4.8);
      expect(entity.isVerifiedPurchase, isTrue);

      final model = ReviewModel.fromEntity(entity);
      expect(model.id, entity.id);
      expect(model.comment, entity.comment);
      expect(model.ratingStars, 5);
    });

    test('GetProductReviewsUseCase returns product reviews', () async {
      final useCase = GetProductReviewsUseCase(repository);
      final results = await useCase('prod-100');

      expect(results.length, 1);
      expect(results.first.id, 'rev-1');
      expect(results.first.userName, 'Ahmed');
      expect(results.first.rating, 4.8);
    });

    test('SubmitReviewUseCase submits new review successfully', () async {
      final useCase = SubmitReviewUseCase(repository);
      final result = await useCase(
        productId: 'prod-100',
        rating: 5.0,
        comment: 'Top quality product!',
      );

      expect(result.id, 'rev-test-1');
      expect(result.rating, 5.0);
      expect(result.comment, 'Top quality product!');
      expect(result.isVerifiedPurchase, isTrue);
    });

    test('GetUserProductReviewUseCase returns user review', () async {
      fakeRemoteDataSource.userReview = sampleModel;
      final useCase = GetUserProductReviewUseCase(repository);
      final result = await useCase('prod-100');

      expect(result, isNotNull);
      expect(result!.id, 'rev-1');
      expect(result.comment, 'Excellent flavor and results!');
    });

    test('DeleteReviewUseCase deletes review from repository', () async {
      final useCase = DeleteReviewUseCase(repository);
      await useCase('rev-1');

      final remaining = await repository.getProductReviews('prod-100');
      expect(remaining, isEmpty);
    });
  });
}
