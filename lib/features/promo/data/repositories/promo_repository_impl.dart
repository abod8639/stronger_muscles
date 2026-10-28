import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/promo/data/datasources/promo_local_datasource.dart';
import 'package:stronger_muscles/features/promo/data/datasources/promo_remote_datasource.dart';
import 'package:stronger_muscles/features/promo/data/mappers/promo_mapper.dart';
import 'package:stronger_muscles/features/promo/domain/entities/promo_entity.dart';
import 'package:stronger_muscles/features/promo/domain/repositories/promo_repository.dart';

/// Single Source of Truth implementation of [PromoRepository].
/// Coordinates between [PromoRemoteDataSource] (Dio) and [PromoLocalDataSource] (Hive).
class PromoRepositoryImpl implements PromoRepository {
  final PromoRemoteDataSource _remoteDataSource;
  final PromoLocalDataSource _localDataSource;

  PromoRepositoryImpl(
    this._remoteDataSource, [
    PromoLocalDataSource? localDataSource,
  ]) : _localDataSource = localDataSource ?? PromoLocalDataSourceImpl();

  @override
  Future<Either<Failure, List<PromoEntity>>> getPromos() async {
    try {
      final models = await _remoteDataSource.getPromos();
      if (models.isNotEmpty) {
        await _localDataSource.cachePromos(models);
      }
      return Right(models.map((model) => model.toEntity()).toList());
    } on Failure catch (failure) {
      return _fallbackCachedPromosOrFailure(failure);
    } on DioException catch (e) {
      return _fallbackCachedPromosOrFailure(_mapDioException(e));
    } on HiveError catch (e, st) {
      return Left(
        CacheFailure(
          message: 'خطأ في قاعدة البيانات المحلية للعروض',
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
      return _fallbackCachedPromosOrFailure(
        Failure(
          message: 'حدث خطأ غير متوقع أثناء جلب العروض الترويجية',
          type: FailureType.unknown,
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  Either<Failure, List<PromoEntity>> _fallbackCachedPromosOrFailure(
    Failure failure,
  ) {
    try {
      final cached = _localDataSource.getCachedPromos();
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
          'حدث خطأ في الاتصال بالخادم أثناء جلب العروض الترويجية',
      statusCode: e.response?.statusCode,
      originalError: e,
    );
  }
}
