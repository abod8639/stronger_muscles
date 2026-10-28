import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_local_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_remote_datasource.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/product_repository.dart';

/// Single Source of Truth implementation of [ProductRepository].
/// Coordinates between [ProductRemoteDataSource] (Dio) and [ProductLocalDataSource] (Hive).
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final ProductLocalDataSource _localDataSource;

  ProductRepositoryImpl(
    this._remoteDataSource, [
    ProductLocalDataSource? localDataSource,
  ]) : _localDataSource = localDataSource ?? ProductLocalDataSource();

  @override
  Either<Failure, List<ProductEntity>> getCachedProducts() {
    try {
      final models = _localDataSource.getCachedProducts();
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e, st) {
      return Left(
        Failure(
          message: 'فشل في قراءة المنتجات المحفوظة محلياً',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    String? categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final models = await _remoteDataSource.getProductsFromApi(
        categoryId: categoryId,
        page: page,
      );
      if (page == 1 && (categoryId == null || categoryId.isEmpty)) {
        await _localDataSource.cacheProducts(models);
      }
      return Right(models.map((m) => m.toEntity()).toList());
    } on Failure catch (failure) {
      return _fallbackCachedProductsOrFailure(failure, categoryId: categoryId);
    } on DioException catch (e) {
      final failure = _mapDioException(e);
      return _fallbackCachedProductsOrFailure(failure, categoryId: categoryId);
    } catch (e, st) {
      final failure = Failure(
        message: 'حدث خطأ غير متوقع أثناء جلب المنتجات',
        type: FailureType.unknown,
        originalError: e,
        stackTrace: st,
      );
      return _fallbackCachedProductsOrFailure(failure, categoryId: categoryId);
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(String id) async {
    final cached = _localDataSource.getProductById(id);
    try {
      final model = await _remoteDataSource.getProductDetailsFromApi(id);
      await _localDataSource.cacheProduct(model);
      return Right(model.toEntity());
    } on Failure catch (failure) {
      if (cached != null) return Right(cached.toEntity());
      return Left(failure);
    } on DioException catch (e) {
      if (cached != null) return Right(cached.toEntity());
      return Left(_mapDioException(e));
    } catch (e, st) {
      if (cached != null) return Right(cached.toEntity());
      return Left(
        Failure(
          message: 'حدث خطأ أثناء جلب تفاصيل المنتج',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query) async {
    try {
      final models = await _remoteDataSource.getProductsFromApi(query: query);
      return Right(models.map((m) => m.toEntity()).toList());
    } on Failure catch (failure) {
      return _fallbackSearchOrFailure(failure, query);
    } on DioException catch (e) {
      return _fallbackSearchOrFailure(_mapDioException(e), query);
    } catch (e, st) {
      return _fallbackSearchOrFailure(
        Failure(
          message: 'حدث خطأ أثناء البحث عن المنتجات',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
        query,
      );
    }
  }

  Either<Failure, List<ProductEntity>> _fallbackCachedProductsOrFailure(
    Failure failure, {
    String? categoryId,
  }) {
    try {
      var cached = _localDataSource.getCachedProducts();
      if (categoryId != null && categoryId.isNotEmpty) {
        cached = cached.where((p) => p.categoryId == categoryId).toList();
      }
      if (cached.isNotEmpty) {
        return Right(cached.map((m) => m.toEntity()).toList());
      }
      return Left(failure);
    } catch (_) {
      return Left(failure);
    }
  }

  Either<Failure, List<ProductEntity>> _fallbackSearchOrFailure(
    Failure failure,
    String query,
  ) {
    try {
      final cached = _localDataSource.getCachedProducts();
      final filtered = cached.where((p) {
        final name = p.getLocalizedName().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();

      if (filtered.isNotEmpty) {
        return Right(filtered.map((m) => m.toEntity()).toList());
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
