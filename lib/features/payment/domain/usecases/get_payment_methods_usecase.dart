import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_method_entity.dart';
import 'package:stronger_muscles/features/payment/domain/repositories/payment_repository.dart';

/// Pure Dart UseCase to retrieve the list of supported and enabled payment methods.
class GetPaymentMethodsUseCase {
  final PaymentRepository _repository;

  const GetPaymentMethodsUseCase(this._repository);

  Future<Either<Failure, List<PaymentMethodEntity>>> call({
    String lang = 'ar',
  }) {
    return _repository.getAvailablePaymentMethods(lang: lang);
  }
}
