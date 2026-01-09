import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/bindings/checkout_controller.dart';
import 'package:stronger_muscles/presentation/bindings/profile_controller.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    Get.put(CheckoutController());
    
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(color: AppColors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Obx(() {
        if (controller.isProcessing.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return Stepper(
          type: StepperType.horizontal,
          currentStep: controller.currentStep.value,
          onStepContinue: () {
            if (controller.currentStep.value == 2) {
              controller.placeOrder();
            } else {
              controller.nextStep();
            }
          },
          onStepCancel: controller.previousStep,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        controller.currentStep.value == 2 ? 'Place Order' : 'Next',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (controller.currentStep.value > 0) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
          steps: [
            _buildAddressStep(theme),
            _buildPaymentStep(theme),
            _buildReviewStep(theme),
          ],
        );
      }),
    );
  }

  Step _buildAddressStep(ThemeData theme) {
    final profileController = Get.find<ProfileController>();
    
    return Step(
      title: const Text('Address'),
      content: Column(
        children: [
          if (profileController.addresses.isEmpty)
            const Text('No addresses found. Please add one in your profile.')
          else
            Obx(() => Column(
              children: profileController.addresses.map((address) {
                final isSelected = controller.selectedAddress.value?.id == address.id;
                return Card(
                  elevation: isSelected ? 2 : 0,
                  color: isSelected ? AppColors.primary.withOpacity(0.05) : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : Colors.grey.shade300,
                    ),
                  ),
                  child: RadioListTile(
                    value: address,
                    groupValue: controller.selectedAddress.value,
                    onChanged: (value) => controller.setAddress(value!),
                    title: Text(address.label??"error", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(address.fullAddress),
                    activeColor: AppColors.primary,
                  ),
                );
              }).toList(),
            )),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              // Navigate to add address (placeholder for now)
              Get.snackbar('Info', 'Add address feature coming soon');
            },
            icon: const Icon(Icons.add),
            label: const Text('Add New Address'),
          ),
        ],
      ),
      isActive: controller.currentStep.value >= 0,
      state: controller.currentStep.value > 0 ? StepState.complete : StepState.editing,
    );
  }

  Step _buildPaymentStep(ThemeData theme) {
    return Step(
      title: const Text('Payment'),
      content: Column(
        children: [
          _buildPaymentOption(
            value: 'cod',
            title: 'Cash on Delivery',
            icon: Icons.money,
          ),
          const SizedBox(height: 8),
          _buildPaymentOption(
            value: 'card',
            title: 'Credit Card',
            icon: Icons.credit_card,
            subtitle: 'Coming soon',
            enabled: false,
          ),
        ],
      ),
      isActive: controller.currentStep.value >= 1,
      state: controller.currentStep.value > 1 ? StepState.complete : StepState.editing,
    );
  }

  Widget _buildPaymentOption({
    required String value,
    required String title,
    required IconData icon,
    String? subtitle,
    bool enabled = true,
  }) {
    return Obx(() {
      final isSelected = controller.selectedPaymentMethod.value == value;
      return Card(
        elevation: isSelected ? 2 : 0,
        color: isSelected ? AppColors.primary.withOpacity(0.05) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: RadioListTile(
          value: value,
          groupValue: controller.selectedPaymentMethod.value,
          onChanged: enabled ? (val) => controller.setPaymentMethod(val.toString()) : null,
          title: Text(title, style: TextStyle(
            fontWeight: FontWeight.bold,
            color: enabled ? null : Colors.grey,
          )),
          subtitle: subtitle != null ? Text(subtitle) : null,
          secondary: Icon(icon, color: enabled ? AppColors.primary : Colors.grey),
          activeColor: AppColors.primary,
        ),
      );
    });
  }

  Step _buildReviewStep(ThemeData theme) {
    final cartController = Get.find<CartController>();
    
    return Step(
      title: const Text('Review'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cartController.cartItems.length,
            itemBuilder: (context, index) {
              final item = cartController.cartItems[index];
              return ListTile(
                leading: Image.network(
                  item.product.imageUrls.first,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image),
                ),
                title: Text(item.product.name),
                subtitle: Text('${item.quantity} x \$${item.product.effectivePrice}'),
                trailing: Text('\$${(item.product.effectivePrice * item.quantity).toStringAsFixed(2)}'),
              );
            },
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '\$${cartController.totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (controller.selectedAddress.value != null) ...[
            const Text('Shipping To:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(controller.selectedAddress.value!.fullAddress),
          ],
          const SizedBox(height: 8),
          const Text('Payment Method:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(controller.selectedPaymentMethod.value == 'cod' ? 'Cash on Delivery' : 'Credit Card'),
        ],
      ),
      isActive: controller.currentStep.value >= 2,
      state: StepState.editing,
    );
  }
}
