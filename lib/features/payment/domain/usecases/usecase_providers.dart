import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/payment/data/repositories/payment_repository.dart';
import 'package:stronger_muscles/features/payment/domain/usecases/initiate_payment_usecase.dart';

final initiatePaymentUseCaseProvider = Provider<InitiatePaymentUseCase>((ref) {
  final repository = ref.watch(paymentRepositoryProvider);
  return InitiatePaymentUseCase(repository);
});
