import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/checkout/domain/entities/checkout_params.dart';
import 'package:stronger_muscles/features/checkout/domain/usecases/usecase_providers.dart';
import 'package:stronger_muscles/features/product/data/repositories/product_repository.dart';
import 'package:stronger_muscles/features/product/presentation/controllers/products_controller.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

part 'checkout_controller.g.dart';

class CheckoutState {
  final int currentStep;
  final AddressEntity? selectedAddress;
  final String selectedPaymentMethod;
  final String notes;
  final bool isProcessing;

  const CheckoutState({
    this.currentStep = 0,
    this.selectedAddress,
    this.selectedPaymentMethod = 'cash',
    this.notes = '',
    this.isProcessing = false,
  });

  CheckoutState copyWith({
    int? currentStep,
    AddressEntity? selectedAddress,
    String? selectedPaymentMethod,
    String? notes,
    bool? isProcessing,
  }) {
    return CheckoutState(
      currentStep: currentStep ?? this.currentStep,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      notes: notes ?? this.notes,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

@riverpod
class CheckoutController extends _$CheckoutController {
  @override
  CheckoutState build() {
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

  Future<void> placeOrder(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    if (state.selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n?.pleaseSelectShippingAddress ??
                'Please select a shipping address',
          ),
        ),
      );
      return;
    }

    state = state.copyWith(isProcessing: true);

    try {
      final cartNotifier = ref.read(cartControllerProvider.notifier);
      final placeOrderUseCase = ref.read(placeOrderUseCaseProvider);

      final params = CheckoutParams(
        addressId: state.selectedAddress!.id,
        paymentMethod: state.selectedPaymentMethod,
        notes: state.notes,
        customerName: state.selectedAddress?.fullName,
        items: cartNotifier.cartItems
            .map((item) => CheckoutItemEntity.fromCartItem(item))
            .toList(),
      );

      await placeOrderUseCase(params);

      await cartNotifier.clearCart();

      // Invalidate local product cache and refresh products provider so stock is updated
      final productLocalDataSource = ref.read(productLocalDataSourceProvider);
      await productLocalDataSource.clearCache();
      ref.invalidate(productsControllerProvider);

      ref.read(routerProvider).go(AppRoutes.orderSuccess);
    } catch (e) {
      if (!context.mounted) return;
      final failedText = l10n?.failedToPlaceOrder ?? 'Failed to place order';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$failedText: $e')),
      );
    } finally {
      state = state.copyWith(isProcessing: false);
    }
  }
}
