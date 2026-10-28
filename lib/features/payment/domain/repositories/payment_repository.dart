import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_method_entity.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';

/// Pure domain repository contract defining payment operations.
abstract class PaymentRepository {
  /// Initiates an online payment session with the specified payment gateway.
  Future<Either<Failure, PaymentResultEntity>> initiatePayment({
    required dynamic orderId,
    String gateway = 'paymob',
    String? firstName,
    String? lastName,
  });

  /// Retrieves the list of supported and enabled payment methods.
  Future<Either<Failure, List<PaymentMethodEntity>>> getAvailablePaymentMethods({
    String lang = 'ar',
  });
}
