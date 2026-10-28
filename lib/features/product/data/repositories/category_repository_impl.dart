import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_local_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_remote_datasource.dart';
import 'package:stronger_muscles/features/product/domain/entities/category_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/category_repository.dart';

/// Single Source of Truth implementation of [CategoryRepository].
/// Coordinates between [CategoryRemoteDataSource] and [CategoryLocalDataSource].
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;
  final CategoryLocalDataSource _localDataSource;

  CategoryRepositoryImpl(
    this._remoteDataSource, [
    CategoryLocalDataSource? localDataSource,
  ]) : _localDataSource = localDataSource ?? CategoryLocalDataSource();

  @override
  Either<Failure, List<CategoryEntity>> getCachedCategories() {
    try {
      final models = _localDataSource.getCachedCategories();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e, st) {
      return Left(
        Failure(
          message: 'فشل في قراءة الأقسام المحفوظة محلياً',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      final models = await _remoteDataSource.fetchCategoriesFromApi();
      if (models.isNotEmpty) {
        await _localDataSource.cacheCategories(models);
      }
      return Right(models.map((m) => m.toEntity()).toList());
    } on Failure catch (failure) {
      return _fallbackCachedCategoriesOrFailure(failure);
    } on DioException catch (e) {
      return _fallbackCachedCategoriesOrFailure(_mapDioException(e));
    } catch (e, st) {
      return _fallbackCachedCategoriesOrFailure(
        Failure(
          message: 'حدث خطأ غير متوقع أثناء جلب الأقسام',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  Either<Failure, List<CategoryEntity>> _fallbackCachedCategoriesOrFailure(
    Failure failure,
  ) {
    try {
      final cached = _localDataSource.getCachedCategories();
      if (cached.isNotEmpty) {
        return Right(cached.map((m) => m.toEntity()).toList());
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
          'حدث خطأ في الاتصال بالخادم أثناء جلب الأقسام',
      statusCode: e.response?.statusCode,
      originalError: e,
    );
  }
}
