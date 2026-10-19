import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_method_entity.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';
import 'package:stronger_muscles/features/payment/domain/usecases/usecase_providers.dart';

final paymentControllerProvider =
    StateNotifierProvider<PaymentController, AsyncValue<PaymentResultEntity?>>(
  (ref) => PaymentController(ref),
);

final availablePaymentMethodsProvider =
    FutureProvider.family<List<PaymentMethodEntity>, String>((ref, lang) async {
  final useCase = ref.watch(getPaymentMethodsUseCaseProvider);
  return useCase(lang: lang);
});

class PaymentController
    extends StateNotifier<AsyncValue<PaymentResultEntity?>> {
  final Ref _ref;

  PaymentController(this._ref) : super(const AsyncData(null));

  Future<PaymentResultEntity?> initiatePayment({
    required dynamic orderId,
    String gateway = 'paymob',
    String? firstName,
    String? lastName,
  }) async {
    state = const AsyncLoading();
    try {
      final useCase = _ref.read(initiatePaymentUseCaseProvider);
      final result = await useCase(
        orderId: orderId,
        gateway: gateway,
        firstName: firstName,
        lastName: lastName,
      );
      state = AsyncData(result);
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}
