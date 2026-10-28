import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/payment/data/datasources/payment_local_datasource.dart';
import 'package:stronger_muscles/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:stronger_muscles/features/payment/data/mappers/payment_mapper.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_method_entity.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';
import 'package:stronger_muscles/features/payment/domain/repositories/payment_repository.dart';

/// Single Source of Truth implementation of [PaymentRepository].
/// Coordinates between [PaymentRemoteDataSource] (Dio) and [PaymentLocalDataSource] (Hive).
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource _remoteDataSource;
  final PaymentLocalDataSource _localDataSource;

  PaymentRepositoryImpl(
    this._remoteDataSource, [
    PaymentLocalDataSource? localDataSource,
  ]) : _localDataSource = localDataSource ?? PaymentLocalDataSourceImpl();

  @override
  Future<Either<Failure, PaymentResultEntity>> initiatePayment({
    required dynamic orderId,
    String gateway = 'paymob',
    String? firstName,
    String? lastName,
  }) async {
    try {
      final model = await _remoteDataSource.initiatePayment(
        orderId: orderId,
        gateway: gateway,
        firstName: firstName,
        lastName: lastName,
      );
      return Right(model.toEntity());
    } on Failure catch (failure) {
      return Left(failure);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(TimeoutFailure());
      }
      if (e.type == DioExceptionType.connectionError) {
        return const Left(NetworkFailure());
      }
      return Left(
        ServerFailure(
          message: e.response?.data?['message']?.toString() ??
              e.message ??
              'حدث خطأ أثناء معالجة الدفع',
          statusCode: e.response?.statusCode,
          originalError: e,
        ),
      );
    } catch (e, st) {
      return Left(
        Failure(
          message: 'حدث خطأ غير متوقع: $e',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<PaymentMethodEntity>>> getAvailablePaymentMethods({
    String lang = 'ar',
  }) async {
    try {
      // 1. Fetch remote available payment methods
      final remoteModels =
          await _remoteDataSource.getPaymentMethods(lang: lang);

      // 2. Cache in Hive for offline access
      await _localDataSource.cachePaymentMethods(remoteModels);

      // 3. Return mapped entities
      final entities = remoteModels.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e, st) {
      // Fallback to locally cached methods if remote fails
      try {
        final cachedModels = await _localDataSource.getCachedPaymentMethods();
        if (cachedModels.isNotEmpty) {
          return Right(cachedModels.map((m) => m.toEntity()).toList());
        }
      } catch (_) {
        // Fallback reading failed as well
      }

      if (e is Failure) {
        return Left(e);
      }

      return Left(
        Failure(
          message: 'فشل في استرجاع طرق الدفع: $e',
          originalError: e,
          stackTrace: st,
        ),
      );
    }
  }
}
