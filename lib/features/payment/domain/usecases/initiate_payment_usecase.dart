import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';
import 'package:stronger_muscles/features/payment/domain/repositories/payment_repository.dart';

/// Pure Dart UseCase to initiate an online payment session for an order.
class InitiatePaymentUseCase {
  final PaymentRepository _repository;

  const InitiatePaymentUseCase(this._repository);

  Future<Either<Failure, PaymentResultEntity>> call({
    required dynamic orderId,
    String gateway = 'paymob',
    String? firstName,
    String? lastName,
  }) {
    return _repository.initiatePayment(
      orderId: orderId,
      gateway: gateway,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
