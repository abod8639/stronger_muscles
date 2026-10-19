import 'package:stronger_muscles/features/payment/data/datasources/payment_remote_datasource.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_method_entity.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';
import 'package:stronger_muscles/features/payment/domain/repositories/payment_repository.dart';

/// Implementation of [PaymentRepository] using [PaymentRemoteDataSource].
class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource _remoteDataSource;

  PaymentRepositoryImpl(this._remoteDataSource);

  @override
  Future<PaymentResultEntity> initiatePayment({
    required dynamic orderId,
    String gateway = 'paymob',
    String? firstName,
    String? lastName,
  }) async {
    final result = await _remoteDataSource.initiatePayment(
      orderId: orderId,
      gateway: gateway,
      firstName: firstName,
      lastName: lastName,
    );
    return result.toEntity();
  }

  @override
  Future<List<PaymentMethodEntity>> getAvailablePaymentMethods({
    String lang = 'ar',
  }) async {
    final models = await _remoteDataSource.getPaymentMethods(lang: lang);
    return models.map((m) => m.toEntity()).toList();
  }
}
