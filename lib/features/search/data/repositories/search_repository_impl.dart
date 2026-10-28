import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/search/data/datasources/search_local_datasource.dart';
import 'package:stronger_muscles/features/search/data/datasources/search_remote_datasource.dart';
import 'package:stronger_muscles/features/search/domain/entities/price_bounds.dart';
import 'package:stronger_muscles/features/search/domain/repositories/search_repository.dart';

/// Single Source of Truth implementation of [SearchRepository].
/// Coordinates between [SearchRemoteDataSource] (Dio) and [SearchLocalDataSource] (Hive).
class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;
  final SearchLocalDataSource _localDataSource;

  SearchRepositoryImpl(
    this._remoteDataSource, [
    SearchLocalDataSource? localDataSource,
  ]) : _localDataSource = localDataSource ?? SearchLocalDataSourceImpl();

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(
    String query,
  ) async {
    try {
      final models = await _remoteDataSource.searchProducts(query);
      if (models.isNotEmpty) {
        await _localDataSource.cacheSearchResults(query, models);
      }
      return Right(models.map((m) => m.toEntity()).toList());
    } on Failure catch (failure) {
      return _fallbackCachedOrFailure(query, failure);
    } on DioException catch (e) {
      return _fallbackCachedOrFailure(query, _mapDioException(e));
    } on HiveError catch (e, st) {
      return Left(
        CacheFailure(
          message: 'خطأ في قاعدة البيانات المحلية أثناء البحث',
          originalError: e,
          stackTrace: st,
        ),
      );
    } on FormatException catch (e, st) {
      return Left(
        ParsingFailure(
          originalError: e,
          stackTrace: st,
        ),
      );
    } catch (e, st) {
      return _fallbackCachedOrFailure(
        query,
        Failure(
          message: 'حدث خطأ غير متوقع أثناء البحث عن المنتجات',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  Either<Failure, List<ProductEntity>> _fallbackCachedOrFailure(
    String query,
    Failure failure,
  ) {
    try {
      final cached = _localDataSource.getCachedSearchResults(query);
      if (cached.isNotEmpty) {
        return Right(cached.map((m) => m.toEntity()).toList());
      }
      return Left(failure);
    } catch (_) {
      return Left(failure);
    }
  }

  @override
  List<ProductEntity> filterByPrice(
    List<ProductEntity> products,
    double min,
    double max,
  ) {
    return products.where((p) => p.price >= min && p.price <= max).toList();
  }

  @override
  PriceBounds calculatePriceBounds(List<ProductEntity> products) {
    if (products.isEmpty) {
      return const PriceBounds(min: 100, max: 10000);
    }
    double minPrice = products.first.price;
    double maxPrice = products.first.price;
    for (final p in products) {
      minPrice = math.min(minPrice, p.price);
      maxPrice = math.max(maxPrice, p.price);
    }
    return PriceBounds(min: minPrice, max: maxPrice);
  }

  @override
  Either<Failure, List<String>> getSearchHistory() {
    try {
      final history = _localDataSource.getSearchHistory();
      return Right(history);
    } catch (e, st) {
      return Left(
        CacheFailure(
          message: 'فشل في استرجاع سجل البحث',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<String>>> addSearchTerm(String term) async {
    try {
      final updated = await _localDataSource.addSearchTerm(term);
      return Right(updated);
    } catch (e, st) {
      return Left(
        CacheFailure(
          message: 'فشل في تحديث سجل البحث',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<String>>> removeSearchTerm(String term) async {
    try {
      final updated = await _localDataSource.removeSearchTerm(term);
      return Right(updated);
    } catch (e, st) {
      return Left(
        CacheFailure(
          message: 'فشل في حذف عنصر من سجل البحث',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> clearSearchHistory() async {
    try {
      await _localDataSource.clearSearchHistory();
      return const Right(unit);
    } catch (e, st) {
      return Left(
        CacheFailure(
          message: 'فشل في مسح سجل البحث',
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
          'حدث خطأ في الاتصال بالخادم أثناء البحث عن المنتجات',
      statusCode: e.response?.statusCode,
      originalError: e,
    );
  }
}
