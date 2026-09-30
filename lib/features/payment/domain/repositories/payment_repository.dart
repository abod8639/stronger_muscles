import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';

/// Domain contract defining payment operations.
abstract class PaymentRepository {
  Future<PaymentResultEntity> initiatePayment({
    required dynamic orderId,
    String gateway = 'paymob',
    String? firstName,
    String? lastName,
  });
}
