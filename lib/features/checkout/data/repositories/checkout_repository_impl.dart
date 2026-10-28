import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import '../../../../core/error/error.dart';
import '../../domain/entities/checkout_params.dart';
import '../../domain/entities/checkout_result_entity.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../datasources/checkout_local_data_source.dart';
import '../datasources/checkout_remote_data_source.dart';
import '../mappers/checkout_mapper.dart';
import '../models/checkout_result_model.dart';

/// Single Source of Truth Repository Implementation for Checkout.
///
/// Orchestrates calls between [CheckoutRemoteDataSource] and [CheckoutLocalDataSource].
/// Pure Dart contract adherence with functional [Either<Failure, T>] error handling.
class CheckoutRepositoryImpl implements CheckoutRepository {
  const CheckoutRepositoryImpl({
    required CheckoutRemoteDataSource remoteDataSource,
    required CheckoutLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final CheckoutRemoteDataSource _remoteDataSource;
  final CheckoutLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, CheckoutResultEntity>> placeOrder(
    CheckoutParams params,
  ) async {
    try {
      final paramsModel = params.toModel();

      // Persist draft locally before transmission
      await _localDataSource.saveDraft(paramsModel);

      // Submit order remotely
      final orderResult = await _remoteDataSource.submitOrder(paramsModel);

      String? paymentUrl = orderResult.paymentUrl;

      // Handle online payment gateway initiation if required
      if (params.isOnlinePayment && orderResult.orderId.isNotEmpty) {
        try {
          paymentUrl = await _remoteDataSource.initiatePayment(
            orderId: orderResult.orderId,
            gateway: params.gateway,
            customerName: params.customerName,
          );
        } catch (_) {
          // The order was already successfully recorded on the server.
          final finalResult = CheckoutResultModel(
            orderId: orderResult.orderId,
            status: orderResult.status,
            message: 'تم تأكيد طلبك رقم (${orderResult.orderId}) بنجاح، لكن تعذر إكمال الدفع الإلكتروني تلقائياً.',
            rawData: orderResult.rawData,
          );
          await _localDataSource.saveLastResult(finalResult);
          await _localDataSource.clearDraft();
          return right(finalResult.toEntity());
        }
      }

      final finalResult = CheckoutResultModel(
        orderId: orderResult.orderId,
        status: orderResult.status,
        message: orderResult.message,
        paymentUrl: paymentUrl,
        rawData: orderResult.rawData,
      );

      // Cache confirmed result & clear temporary draft
      await _localDataSource.saveLastResult(finalResult);
      await _localDataSource.clearDraft();

      return right(finalResult.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on TimeoutAppException catch (e) {
      return left(TimeoutFailure(message: e.message));
    } on CancelAppException catch (e) {
      return left(CancelFailure(message: e.message));
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    } on HiveError catch (e) {
      return left(CacheFailure(message: e.message));
    } on FormatException catch (e) {
      return left(ServerFailure(message: 'خطأ في تنسيق استجابة الخادم: ${e.message}'));
    } catch (e) {
      return left(GeneralFailure(message: e.toString()));
    }
  }
}
