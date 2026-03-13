import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/order/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/profile/data/models/address_model.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/profile_controller.dart';
import 'package:stronger_muscles/routes/routes.dart';

part 'checkout_controller.g.dart';

class CheckoutState {
  final int currentStep;
  final AddressModel? selectedAddress;
  final String selectedPaymentMethod;
  final bool isProcessing;

  CheckoutState({
    this.currentStep = 0,
    this.selectedAddress,
    this.selectedPaymentMethod = 'cash',
    this.isProcessing = false,
  });

  CheckoutState copyWith({
    int? currentStep,
    AddressModel? selectedAddress,
    String? selectedPaymentMethod,
    bool? isProcessing,
  }) {
    return CheckoutState(
      currentStep: currentStep ?? this.currentStep,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      isProcessing: isProcessing ?? this.isProcessing,
    );
  }
}

@riverpod
class CheckoutController extends _$CheckoutController {
  @override
  CheckoutState build() {
    final profileNotifier = ref.watch(profileControllerProvider.notifier);
    final addresses = profileNotifier.addresses;
    
    AddressModel? initialAddress;
    if (addresses.isNotEmpty) {
      initialAddress = addresses.where((addr) => addr.isDefault).firstOrNull ?? addresses.first;
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

  void setAddress(AddressModel address) {
    state = state.copyWith(selectedAddress: address);
  }

  void setPaymentMethod(String method) {
    state = state.copyWith(selectedPaymentMethod: method);
  }

  Future<void> placeOrder(BuildContext context) async {
    if (state.selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a shipping address')),
      );
      return;
    }

    state = state.copyWith(isProcessing: true);

    try {
      final cartNotifier = ref.read(cartControllerProvider.notifier);
      final orderRepository = ref.read(orderRepositoryProvider);
      
      final payload = {
        "address_id": state.selectedAddress!.id,
        "payment_method": state.selectedPaymentMethod,
        "notes": cartNotifier.notesController.text,
        "items": cartNotifier.cartItems.map((item) {
          return {
            "product_id": item.product.id,
            "quantity": item.quantity,
            "selected_flavor": item.selectedFlavor,
            "selected_size": item.selectedSize,
          };
        }).toList(),
      };

      await orderRepository.createOrder(payload);
      await cartNotifier.clearCart();
      AppPages.router.go(AppRoutes.orderSuccess);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: $e')),
      );
    } finally {
      state = state.copyWith(isProcessing: false);
    }
  }
}
