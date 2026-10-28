import 'dart:async';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/profile/data/datasources/address_local_datasource.dart';
import 'package:stronger_muscles/features/profile/data/datasources/address_remote_datasource.dart';
import 'package:stronger_muscles/features/profile/data/datasources/address_service.dart';
import 'package:stronger_muscles/features/profile/data/mappers/address_mapper.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/domain/repositories/address_repository.dart';

part 'address_repository_impl.g.dart';

@Riverpod(keepAlive: true)
AddressRepository addressRepository(AddressRepositoryRef ref) {
  return AddressRepositoryImpl(
    remoteDataSource: ref.watch(addressServiceProvider),
    localDataSource: AddressLocalDataSourceImpl(),
  );
}

/// Single Source of Truth implementation of [AddressRepository].
/// Coordinates between [AddressRemoteDataSource] and [AddressLocalDataSource]
/// with functional error handling via [Either].
class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource _remoteDataSource;
  final AddressLocalDataSource _localDataSource;

  AddressRepositoryImpl({
    required AddressRemoteDataSource remoteDataSource,
    AddressLocalDataSource? localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource ?? AddressLocalDataSourceImpl();

  Completer<Either<Failure, List<AddressEntity>>>? _fetchCompleter;

  @override
  Either<Failure, List<AddressEntity>> getCachedAddresses() {
    try {
      final cached = _localDataSource.getCachedAddresses();
      return Right(cached.map((m) => m.toDomain()).toList());
    } on HiveError catch (e, st) {
      return Left(
        CacheFailure(
          message: 'خطأ في قراءة العناوين المخزنة محلياً',
          originalError: e,
          stackTrace: st,
        ),
      );
    } catch (e, st) {
      return Left(
        CacheFailure(
          message: 'فشل استرجاع العناوين المخزنة محلياً',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<AddressEntity>>> getAddresses() async {
    if (_fetchCompleter != null) {
      return _fetchCompleter!.future;
    }

    _fetchCompleter = Completer<Either<Failure, List<AddressEntity>>>();

    try {
      final models = await _remoteDataSource.getAddresses();
      await _localDataSource.cacheAddresses(models);
      final entities = models.map((m) => m.toDomain()).toList();
      final result = Right<Failure, List<AddressEntity>>(entities);
      _fetchCompleter!.complete(result);
      return result;
    } on Failure catch (failure) {
      final result = _fallbackCachedOrFailure(failure);
      _fetchCompleter!.complete(result);
      return result;
    } on DioException catch (e, st) {
      final failure = _mapDioException(e, st);
      final result = _fallbackCachedOrFailure(failure);
      _fetchCompleter!.complete(result);
      return result;
    } on HiveError catch (e, st) {
      final failure = Left<Failure, List<AddressEntity>>(
        CacheFailure(
          message: 'خطأ في قاعدة البيانات المحلية',
          originalError: e,
          stackTrace: st,
        ),
      );
      _fetchCompleter!.complete(failure);
      return failure;
    } on FormatException catch (e, st) {
      final failure = Left<Failure, List<AddressEntity>>(
        ParsingFailure(
          message: 'خطأ في معالجة بيانات العناوين',
          originalError: e,
          stackTrace: st,
        ),
      );
      _fetchCompleter!.complete(failure);
      return failure;
    } catch (e, st) {
      final failure = UnknownFailure(
        message: 'حدث خطأ غير متوقع أثناء جلب العناوين',
        originalError: e,
        stackTrace: st,
      );
      final result = _fallbackCachedOrFailure(failure);
      _fetchCompleter!.complete(result);
      return result;
    } finally {
      _fetchCompleter = null;
    }
  }

  Either<Failure, List<AddressEntity>> _fallbackCachedOrFailure(
    Failure failure,
  ) {
    try {
      final cached = _localDataSource.getCachedAddresses();
      if (cached.isNotEmpty) {
        return Right(cached.map((m) => m.toDomain()).toList());
      }
    } catch (_) {}
    return Left(failure);
  }

  @override
  Future<Either<Failure, AddressEntity>> createAddress(
    AddressEntity address,
  ) async {
    try {
      final model = address.toModel();
      final createdModel = await _remoteDataSource.createAddress(model);
      await _localDataSource.cacheAddress(createdModel);
      return Right(createdModel.toDomain());
    } on Failure catch (failure) {
      return Left(failure);
    } on DioException catch (e, st) {
      return Left(_mapDioException(e, st));
    } on HiveError catch (e, st) {
      return Left(
        CacheFailure(
          message: 'خطأ في حفظ العنوان محلياً',
          originalError: e,
          stackTrace: st,
        ),
      );
    } on FormatException catch (e, st) {
      return Left(
        ParsingFailure(
          message: 'خطأ في معالجة استجابة إضافة العنوان',
          originalError: e,
          stackTrace: st,
        ),
      );
    } catch (e, st) {
      return Left(
        UnknownFailure(
          message: 'فشل إضافة العنوان',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> updateAddress(
    int id,
    AddressEntity address,
  ) async {
    try {
      final model = address.toModel();
      final updatedModel = await _remoteDataSource.updateAddress(id, model);
      await _localDataSource.cacheAddress(updatedModel);
      return Right(updatedModel.toDomain());
    } on Failure catch (failure) {
      return Left(failure);
    } on DioException catch (e, st) {
      return Left(_mapDioException(e, st));
    } on HiveError catch (e, st) {
      return Left(
        CacheFailure(
          message: 'خطأ في تحديث العنوان محلياً',
          originalError: e,
          stackTrace: st,
        ),
      );
    } on FormatException catch (e, st) {
      return Left(
        ParsingFailure(
          message: 'خطأ في معالجة استجابة تحديث العنوان',
          originalError: e,
          stackTrace: st,
        ),
      );
    } catch (e, st) {
      return Left(
        UnknownFailure(
          message: 'فشل تحديث العنوان',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAddress(int id) async {
    try {
      await _remoteDataSource.deleteAddress(id);
      await _localDataSource.deleteAddress(id);
      return const Right(unit);
    } on Failure catch (failure) {
      return Left(failure);
    } on DioException catch (e, st) {
      return Left(_mapDioException(e, st));
    } on HiveError catch (e, st) {
      return Left(
        CacheFailure(
          message: 'خطأ في حذف العنوان محلياً',
          originalError: e,
          stackTrace: st,
        ),
      );
    } catch (e, st) {
      return Left(
        UnknownFailure(
          message: 'فشل حذف العنوان',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, AddressEntity>> setDefaultAddress(int id) async {
    try {
      final updatedModel = await _remoteDataSource.setDefaultAddress(id);
      await _localDataSource.setDefaultAddress(id, updatedModel);
      return Right(updatedModel.toDomain());
    } on Failure catch (failure) {
      return Left(failure);
    } on DioException catch (e, st) {
      return Left(_mapDioException(e, st));
    } on HiveError catch (e, st) {
      return Left(
        CacheFailure(
          message: 'خطأ في تعيين العنوان الافتراضي محلياً',
          originalError: e,
          stackTrace: st,
        ),
      );
    } catch (e, st) {
      return Left(
        UnknownFailure(
          message: 'فشل تعيين العنوان الافتراضي',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  Failure _mapDioException(DioException e, StackTrace st) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure(originalError: e, stackTrace: st);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data is Map<String, dynamic>
            ? (e.response?.data['message'] as String? ?? 'خطأ في استجابة الخادم')
            : 'خطأ في استجابة الخادم ($statusCode)';
        return ServerFailure(
          message: message,
          statusCode: statusCode,
          originalError: e,
          stackTrace: st,
        );
      case DioExceptionType.cancel:
        return CancelFailure(originalError: e, stackTrace: st);
      case DioExceptionType.connectionError:
        return NetworkFailure(originalError: e, stackTrace: st);
      default:
        return UnknownFailure(
          message: e.message ?? 'حدث خطأ غير متوقع في الاتصال',
          originalError: e,
          stackTrace: st,
        );
    }
  }
}
