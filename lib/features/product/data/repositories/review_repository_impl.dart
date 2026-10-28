import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/data/datasources/review_remote_datasource.dart';
import 'package:stronger_muscles/features/product/domain/entities/review_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/review_repository.dart';

/// Concrete implementation of [ReviewRepository] with functional error handling via `fpdart`.
class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource _remoteDataSource;

  ReviewRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ReviewEntity>>> getProductReviews(
    String productId, {
    int page = 1,
  }) async {
    try {
      final models = await _remoteDataSource.getProductReviews(
        productId,
        page: page,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on Failure catch (failure) {
      return Left(failure);
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e, st) {
      return Left(
        Failure(
          message: 'فشل في جلب تقييمات المنتج',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ReviewEntity?>> getUserProductReview(
    String productId,
  ) async {
    try {
      final model = await _remoteDataSource.getUserProductReview(productId);
      return Right(model?.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e, st) {
      return Left(
        Failure(
          message: 'فشل في التحقق من تقييم المستخدم',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> submitReview({
    required String productId,
    required double rating,
    required String comment,
  }) async {
    try {
      final model = await _remoteDataSource.submitReview(
        productId: productId,
        rating: rating,
        comment: comment,
      );
      return Right(model.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e, st) {
      return Left(
        Failure(
          message: 'فشل في إرسال التقييم',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteReview(String reviewId) async {
    try {
      await _remoteDataSource.deleteReview(reviewId);
      return const Right(unit);
    } on Failure catch (failure) {
      return Left(failure);
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e, st) {
      return Left(
        Failure(
          message: 'فشل في حذف التقييم',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  Failure _mapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const TimeoutFailure();
    }
    if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure();
    }
    return ServerFailure(
      message: e.response?.data?['message']?.toString() ??
          e.message ??
          'حدث خطأ في الاتصال بالخادم أثناء معالجة التقييم',
      statusCode: e.response?.statusCode,
      originalError: e,
    );
  }
}
