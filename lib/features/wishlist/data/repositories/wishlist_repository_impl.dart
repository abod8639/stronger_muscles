import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/wishlist/data/datasources/wishlist_local_datasource.dart';
import 'package:stronger_muscles/features/wishlist/data/datasources/wishlist_remote_datasource.dart';
import 'package:stronger_muscles/features/wishlist/domain/repositories/wishlist_repository.dart';

/// Single Source of Truth implementation of [WishlistRepository].
/// Coordinates between [WishlistRemoteDataSource] (Dio) and [WishlistLocalDataSource] (Hive).
class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDataSource _localDataSource;
  final WishlistRemoteDataSource _remoteDataSource;

  WishlistRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
  );

  @override
  Future<Either<Failure, List<ProductEntity>>> getWishlistItems() async {
    try {
      // 1. Fetch remote updates
      try {
        final remoteItems = await _remoteDataSource.getWishlist();
        for (final item in remoteItems) {
          // If remote item exists but not cached, we preserve cached product structure
          if (!_localDataSource.contains(item.productId)) {
            final fallbackEntity = ProductEntity(
              id: item.productId,
              name: LocalizedStringEntity(en: item.productName ?? ''),
              price: item.productPrice ?? 0.0,
              imageUrls: item.productImageUrl != null && item.productImageUrl!.isNotEmpty
                  ? [
                      ImageUrlEntity(
                        thumbnail: item.productImageUrl!,
                        medium: item.productImageUrl!,
                        original: item.productImageUrl!,
                      ),
                    ]
                  : const [],
            );
            _localDataSource.put(
              item.productId,
              _serializeProduct(fallbackEntity),
            );
          }
        }
      } catch (_) {
        // Network failures fall back cleanly to local Hive storage
      }

      // 2. Read all cached products
      final localProducts = _loadCachedProducts();
      return Right(localProducts);
    } on Failure catch (failure) {
      return _fallbackCachedOrFailure(failure);
    } on DioException catch (e) {
      return _fallbackCachedOrFailure(_mapDioException(e));
    } on HiveError catch (e, st) {
      return Left(
        CacheFailure(
          message: 'خطأ في قاعدة البيانات المحلية لقائمة الرغبات',
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
        Failure(
          message: 'حدث خطأ غير متوقع في قائمة الرغبات',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Either<Failure, List<ProductEntity>> getCachedWishlist() {
    try {
      final items = _loadCachedProducts();
      return Right(items);
    } on HiveError catch (e, st) {
      return Left(
        CacheFailure(
          message: 'تعذر قراءة قائمة الرغبات المخزنة محلياً',
          originalError: e,
          stackTrace: st,
        ),
      );
    } catch (e, st) {
      return Left(
        Failure(
          message: 'خطأ غير متوقع أثناء قراءة قائمة الرغبات',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> addToWishlist(ProductEntity product) async {
    try {
      final serialized = _serializeProduct(product);
      _localDataSource.put(product.id, serialized);

      // Async background sync with remote
      try {
        await _remoteDataSource.addToWishlist(product.id);
      } catch (_) {
        // Silently tolerate remote sync failures in offline/local-first mode
      }

      return const Right(unit);
    } on HiveError catch (e, st) {
      return Left(
        CacheFailure(
          message: 'تعذر حفظ المنتج في قائمة الرغبات المحلية',
          originalError: e,
          stackTrace: st,
        ),
      );
    } catch (e, st) {
      return Left(
        Failure(
          message: 'تعذر إضافة المنتج إلى قائمة الرغبات',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> removeFromWishlist(ProductEntity product) async {
    try {
      _localDataSource.remove(product.id);

      // Async background sync with remote
      try {
        await _remoteDataSource.removeFromWishlist(product.id);
      } catch (_) {
        // Silently tolerate remote sync failures in offline/local-first mode
      }

      return const Right(unit);
    } on HiveError catch (e, st) {
      return Left(
        CacheFailure(
          message: 'تعذر حذف المنتج من قاعدة البيانات المحلية',
          originalError: e,
          stackTrace: st,
        ),
      );
    } catch (e, st) {
      return Left(
        Failure(
          message: 'تعذر حذف المنتج من قائمة الرغبات',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Either<Failure, bool> isInWishlist(String productId) {
    try {
      final exists = _localDataSource.contains(productId);
      return Right(exists);
    } catch (e, st) {
      return Left(
        Failure(
          message: 'تعذر التحقق من وجود المنتج في قائمة الرغبات',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  // --- Private Helpers ---

  List<ProductEntity> _loadCachedProducts() {
    final rawList = _localDataSource.getAllRaw();
    return rawList
        .map(_deserializeProduct)
        .whereType<ProductEntity>()
        .toList();
  }

  Either<Failure, List<ProductEntity>> _fallbackCachedOrFailure(
    Failure failure,
  ) {
    try {
      final cached = _loadCachedProducts();
      if (cached.isNotEmpty) {
        return Right(cached);
      }
      return Left(failure);
    } catch (_) {
      return Left(failure);
    }
  }

  String _serializeProduct(ProductEntity product) {
    final model = ProductModel.fromEntity(product);
    return jsonEncode(model.toJson());
  }

  ProductEntity? _deserializeProduct(String rawJson) {
    try {
      final dynamic decoded = jsonDecode(rawJson);
      if (decoded is Map<String, dynamic>) {
        return ProductModel.fromJson(decoded).toEntity();
      }
      return null;
    } catch (_) {
      return null;
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
          'حدث خطأ في الاتصال بالخادم أثناء مزامنة قائمة الرغبات',
      statusCode: e.response?.statusCode,
      originalError: e,
    );
  }
}
