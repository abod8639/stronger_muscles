import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_result_entity.dart';
import 'package:stronger_muscles/features/payment/domain/usecases/get_payment_methods_usecase.dart';
import 'package:stronger_muscles/features/payment/domain/usecases/initiate_payment_usecase.dart';
import 'package:stronger_muscles/features/payment/presentation/controllers/payment_state.dart';

/// StateNotifier responsible for orchestrating payment flows.
/// Strictly enforces Clean Architecture, zero try-catch, and duplicate submission guards.
class PaymentController extends StateNotifier<PaymentState> {
  final InitiatePaymentUseCase _initiatePaymentUseCase;
  final GetPaymentMethodsUseCase _getPaymentMethodsUseCase;

  PaymentController(
    this._initiatePaymentUseCase,
    this._getPaymentMethodsUseCase,
  ) : super(const PaymentState());

  /// Selects a specific payment method ID.
  void selectPaymentMethod(String methodId) {
    if (state.selectedMethodId == methodId) return;
    state = state.copyWith(selectedMethodId: methodId);
  }

  /// Loads available payment methods.
  Future<void> loadPaymentMethods({String lang = 'ar'}) async {
    state = state.copyWith(isLoadingMethods: true, clearErrorMessage: true);

    final result = await _getPaymentMethodsUseCase(lang: lang);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoadingMethods: false,
          failure: failure,
          errorMessage: failure.message,
        );
      },
      (methods) {
        // Automatically default selected method to first enabled if none selected
        String selected = state.selectedMethodId;
        if (methods.isNotEmpty && !methods.any((m) => m.id == selected)) {
          selected = methods.firstWhere((m) => m.isEnabled, orElse: () => methods.first).id;
        }

        state = state.copyWith(
          isLoadingMethods: false,
          methods: methods,
          selectedMethodId: selected,
        );
      },
    );
  }

  /// Initiates an online payment transaction with strict double-submission guard clauses.
  Future<PaymentResultEntity?> initiatePayment({
    required dynamic orderId,
    String gateway = 'paymob',
    String? firstName,
    String? lastName,
  }) async {
    // 1. Guard against duplicate submissions while loading
    if (state.isInitiating) return null;

    // 2. Set loading state
    state = state.copyWith(
      isInitiating: true,
      clearFailure: true,
      clearErrorMessage: true,
    );

    // 3. Execute pure UseCase
    final result = await _initiatePaymentUseCase(
      orderId: orderId,
      gateway: gateway,
      firstName: firstName,
      lastName: lastName,
    );

    // 4. Map functional result without try-catch
    return result.fold(
      (failure) {
        state = state.copyWith(
          isInitiating: false,
          failure: failure,
          errorMessage: failure.message,
        );
        return null;
      },
      (paymentResult) {
        state = state.copyWith(
          isInitiating: false,
          result: paymentResult,
        );
        return paymentResult;
      },
    );
  }

  /// Resets transaction state.
  void reset() {
    state = state.copyWith(
      clearResult: true,
      clearFailure: true,
      clearErrorMessage: true,
    );
  }
}
