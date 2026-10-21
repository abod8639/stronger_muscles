import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/checkout/domain/entities/checkout_params.dart';
import 'package:stronger_muscles/features/checkout/domain/entities/checkout_result_entity.dart';
import 'package:stronger_muscles/features/checkout/domain/usecases/usecase_providers.dart';
import 'package:stronger_muscles/features/product/data/repositories/product_repository.dart';
import 'package:stronger_muscles/features/product/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/address_controller.dart';

part 'checkout_controller.g.dart';

@immutable
class CheckoutState {
  final int currentStep;
  final AddressEntity? selectedAddress;
  final String selectedPaymentMethod;
  final String notes;
  final AsyncValue<CheckoutResultEntity?> orderSubmission;

  const CheckoutState({
    this.currentStep = 0,
    this.selectedAddress,
    this.selectedPaymentMethod = 'cash',
    this.notes = '',
    this.orderSubmission = const AsyncData(null),
  });

  /// True while order placement or payment initiation is executing
  bool get isProcessing => orderSubmission.isLoading;

  /// True if placing the order produced an error
  bool get hasError => orderSubmission.hasError;

  /// Safely extracts the typed [Failure] if available
  Failure? get failure {
    final err = orderSubmission.error;
    if (err is Failure) return err;
    if (err != null) return Failure(message: err.toString());
    return null;
  }

  CheckoutState copyWith({
    int? currentStep,
    AddressEntity? selectedAddress,
    String? selectedPaymentMethod,
    String? notes,
    AsyncValue<CheckoutResultEntity?>? orderSubmission,
    bool? isProcessing,
  }) {
    AsyncValue<CheckoutResultEntity?> newSubmission =
        orderSubmission ?? this.orderSubmission;

    if (isProcessing != null) {
      newSubmission = isProcessing
          ? const AsyncLoading()
          : (this.orderSubmission.isLoading
              ? const AsyncData(null)
              : this.orderSubmission);
    }

    return CheckoutState(
      currentStep: currentStep ?? this.currentStep,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      notes: notes ?? this.notes,
      orderSubmission: newSubmission,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckoutState &&
          runtimeType == other.runtimeType &&
          currentStep == other.currentStep &&
          selectedAddress == other.selectedAddress &&
          selectedPaymentMethod == other.selectedPaymentMethod &&
          notes == other.notes &&
          orderSubmission == other.orderSubmission;

  @override
  int get hashCode => Object.hash(
        currentStep,
        selectedAddress,
        selectedPaymentMethod,
        notes,
        orderSubmission,
      );
}

@riverpod
class CheckoutController extends _$CheckoutController {
  CancelToken? _cancelToken;

  @override
  CheckoutState build() {
    _cancelToken = CancelToken();

    // Prevent resource leakage by cancelling any in-flight order request when leaving checkout
    ref.onDispose(() {
      _cancelToken?.cancel('Checkout controller disposed');
    });

    ref.listen<AsyncValue<List<AddressEntity>>>(addressControllerProvider, (previous, next) {
      final newAddresses = next.value ?? [];
      if (state.selectedAddress == null && newAddresses.isNotEmpty) {
        final defaultAddr = newAddresses.where((addr) => addr.isDefault).firstOrNull ?? newAddresses.first;
        state = state.copyWith(selectedAddress: defaultAddr);
      } else if (state.selectedAddress != null) {
        final stillExists = newAddresses.any((addr) => addr.id == state.selectedAddress!.id);
        if (!stillExists) {
          final defaultAddr = newAddresses.where((addr) => addr.isDefault).firstOrNull ?? (newAddresses.isNotEmpty ? newAddresses.first : null);
          state = state.copyWith(selectedAddress: defaultAddr);
        } else {
          final updatedAddr = newAddresses.firstWhere((addr) => addr.id == state.selectedAddress!.id);
          state = state.copyWith(selectedAddress: updatedAddr);
        }
      }
    });

    final addresses = ref.read(addressControllerProvider).value ?? [];

    AddressEntity? initialAddress;
    if (addresses.isNotEmpty) {
      initialAddress =
          addresses.where((addr) => addr.isDefault).firstOrNull ??
          addresses.first;
    }

    return CheckoutState(selectedAddress: initialAddress);
  }

  void nextStep() {
    if (state.currentStep < 2) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void setAddress(AddressEntity address) {
    state = state.copyWith(selectedAddress: address);
  }

  void setPaymentMethod(String method) {
    state = state.copyWith(selectedPaymentMethod: method);
  }

  void setNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  /// Resets the error status to allow retry without dismissing whole form
  void resetError() {
    if (state.orderSubmission.hasError) {
      state = state.copyWith(orderSubmission: const AsyncData(null));
    }
  }

  /// Places order cleanly without UI dependencies or direct BuildContext manipulation.
  /// Optional [context] parameter preserved for backward-compatibility.
  Future<void> placeOrder([BuildContext? context]) async {
    if (state.selectedAddress == null) {
      state = state.copyWith(
        orderSubmission: AsyncError(
          const ValidationFailure(
            message: 'يرجى تحديد عنوان التوصيل أولاً قبل إتمام الطلب',
          ),
          StackTrace.current,
        ),
      );
      return;
    }

    final cartNotifier = ref.read(cartControllerProvider.notifier);
    final cartItems = cartNotifier.cartItems;
    if (cartItems.isEmpty) {
      state = state.copyWith(
        orderSubmission: AsyncError(
          const ValidationFailure(
            message: 'سلة المشتريات فارغة، يرجى إضافة منتجات أولاً',
          ),
          StackTrace.current,
        ),
      );
      return;
    }

    state = state.copyWith(orderSubmission: const AsyncLoading());

    try {
      final placeOrderUseCase = ref.read(placeOrderUseCaseProvider);

      final checkoutItems = cartItems
          .map((item) => CheckoutItemEntity.fromCartItem(item))
          .toList();

      final params = CheckoutParams(
        addressId: state.selectedAddress!.id,
        paymentMethod: state.selectedPaymentMethod,
        notes: state.notes,
        customerName: state.selectedAddress?.fullName,
        items: checkoutItems,
      );

      final resultEither = await placeOrderUseCase(
        params,
        cancelToken: _cancelToken,
      );

      await resultEither.fold(
        (failure) async {
          state = state.copyWith(
            orderSubmission: AsyncError(
              failure,
              failure.stackTrace ?? StackTrace.current,
            ),
          );
        },
        (result) async {
          // Clear cart and invalidate cache upon confirmed order
          await cartNotifier.clearCart();

          final productLocalDataSource = ref.read(productLocalDataSourceProvider);
          await productLocalDataSource.clearCache();
          ref.invalidate(productsControllerProvider);

          state = state.copyWith(
            orderSubmission: AsyncData(result),
          );
        },
      );
    } catch (e, stackTrace) {
      final failure = NetworkErrorHandler.handle(e, stackTrace);
      state = state.copyWith(
        orderSubmission: AsyncError(failure, stackTrace),
      );
    }
  }
}
