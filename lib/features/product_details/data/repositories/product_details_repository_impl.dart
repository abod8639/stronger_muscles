import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/product_details/data/datasources/product_details_local_datasource.dart';
import 'package:stronger_muscles/features/product_details/data/datasources/product_details_remote_datasource.dart';
import 'package:stronger_muscles/features/product_details/data/mappers/product_details_mapper.dart';
import 'package:stronger_muscles/features/product_details/domain/repositories/product_details_repository.dart';

/// Single Source of Truth implementation of [ProductDetailsRepository].
/// Coordinates between [ProductDetailsRemoteDataSource] and [ProductDetailsLocalDataSource].
class ProductDetailsRepositoryImpl implements ProductDetailsRepository {
  final ProductDetailsRemoteDataSource _remoteDataSource;
  final ProductDetailsLocalDataSource _localDataSource;

  ProductDetailsRepositoryImpl(
    this._remoteDataSource, [
    ProductDetailsLocalDataSource? localDataSource,
  ]) : _localDataSource = localDataSource ?? ProductDetailsLocalDataSource();

  @override
  Future<Either<Failure, ProductEntity>> getProductDetails(String productId) async {
    try {
      final model = await _remoteDataSource.getProductDetails(productId);
      await _localDataSource.cacheProduct(model);
      return Right(model.toDomainEntity());
    } on Failure catch (failure) {
      return _fallbackCachedProductOrFailure(failure, productId);
    } on DioException catch (e) {
      final failure = _mapDioException(e);
      return _fallbackCachedProductOrFailure(failure, productId);
    } on HiveError catch (e, st) {
      return Left(
        Failure(
          message: 'خطأ في قاعدة البيانات المحلية',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    } on FormatException catch (e, st) {
      return Left(
        Failure(
          message: 'خطأ في معالجة بيانات المنتج',
          type: FailureType.parsing,
          originalError: e,
          stackTrace: st,
        ),
      );
    } catch (e, st) {
      final failure = Failure(
        message: 'حدث خطأ غير متوقع أثناء جلب تفاصيل المنتج',
        type: FailureType.unknown,
        originalError: e,
        stackTrace: st,
      );
      return _fallbackCachedProductOrFailure(failure, productId);
    }
  }

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
      if (page == 1) {
        await _localDataSource.cacheReviews(productId, models);
      }
      return Right(models.map((m) => m.toDomainEntity()).toList());
    } on Failure catch (failure) {
      return _fallbackCachedReviewsOrFailure(failure, productId);
    } on DioException catch (e) {
      final failure = _mapDioException(e);
      return _fallbackCachedReviewsOrFailure(failure, productId);
    } on HiveError catch (e, st) {
      return Left(
        Failure(
          message: 'خطأ في قراءة التقييمات المخزنة محلياً',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    } on FormatException catch (e, st) {
      return Left(
        Failure(
          message: 'خطأ في معالجة بيانات التقييمات',
          type: FailureType.parsing,
          originalError: e,
          stackTrace: st,
        ),
      );
    } catch (e, st) {
      final failure = Failure(
        message: 'حدث خطأ غير متوقع أثناء جلب التقييمات',
        type: FailureType.unknown,
        originalError: e,
        stackTrace: st,
      );
      return _fallbackCachedReviewsOrFailure(failure, productId);
    }
  }

  @override
  Future<Either<Failure, ReviewEntity?>> getUserProductReview(String productId) async {
    try {
      final model = await _remoteDataSource.getUserProductReview(productId);
      return Right(model?.toDomainEntity());
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e, st) {
      return Left(
        Failure(
          message: 'حدث خطأ أثناء جلب تقييم المستخدم',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> submitProductReview({
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
      return Right(model.toDomainEntity());
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e, st) {
      return Left(
        Failure(
          message: 'حدث خطأ أثناء حفظ التقييم',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProductReview(String reviewId) async {
    try {
      await _remoteDataSource.deleteReview(reviewId);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e, st) {
      return Left(
        Failure(
          message: 'حدث خطأ أثناء حذف التقييم',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  Either<Failure, ProductEntity> _fallbackCachedProductOrFailure(
    Failure failure,
    String productId,
  ) {
    try {
      final cached = _localDataSource.getCachedProduct(productId);
      if (cached != null) {
        return Right(cached.toDomainEntity());
      }
      return Left(failure);
    } catch (_) {
      return Left(failure);
    }
  }

  Either<Failure, List<ReviewEntity>> _fallbackCachedReviewsOrFailure(
    Failure failure,
    String productId,
  ) {
    try {
      final cached = _localDataSource.getCachedReviews(productId);
      if (cached != null && cached.isNotEmpty) {
        return Right(cached.map((m) => m.toDomainEntity()).toList());
      }
      return Left(failure);
    } catch (_) {
      return Left(failure);
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
          'حدث خطأ في الاتصال بالخادم',
      statusCode: e.response?.statusCode,
      originalError: e,
    );
  }
}
