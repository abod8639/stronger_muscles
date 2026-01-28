import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/functions/app_guard.dart';
import 'package:stronger_muscles/functions/cache_manager.dart';
import 'package:stronger_muscles/functions/show_address_form.dart';
import 'package:stronger_muscles/presentation/controllers/checkout_controller.dart';
import 'package:stronger_muscles/presentation/controllers/profile_controller.dart';
import 'package:stronger_muscles/presentation/controllers/cart_controller.dart';

const String _checkoutTitle = 'Checkout';
const String _addressStepTitle = 'Address';
const String _paymentStepTitle = 'Payment';
const String _reviewStepTitle = 'Review';
const String _nextButtonText = 'Next';
const String _placeOrderButtonText = 'Place Order';
const String _backButtonText = 'Back';
const double _controlsPadding = 20.0;
const double _controlsSpacing = 12.0;
const double _controlsVerticalPadding = 12.0;

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    Get.find<CheckoutController>();

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(_checkoutTitle, style: TextStyle(color: AppColors.white)),
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
            AppGuard.runSafe(() async {
              if (controller.currentStep.value == 2) {
                await controller.placeOrder();
              } else {
                controller.nextStep();
              }
            });
          },
          onStepCancel: controller.previousStep,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: _controlsPadding),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: _controlsVerticalPadding),
                      ),
                      child: Text(
                        controller.currentStep.value == 2
                            ? _placeOrderButtonText
                            : _nextButtonText,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (controller.currentStep.value > 0) ...[
                    const SizedBox(width: _controlsSpacing),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: _controlsVerticalPadding),
                        ),
                        child: const Text(_backButtonText),
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
      title: const Text(_addressStepTitle),
      content: Builder(
        builder: (context) {
          return Column(
            children: [
              if (profileController.addresses.isEmpty)
                const Text(
                  'No addresses found. Please add one in your profile.',
                )
              else
                Obx(
                  () => Column(
                    children: profileController.addresses.map((address) {
                      final isSelected =
                          controller.selectedAddress.value?.id == address.id;
                      return Card(
                        elevation: isSelected ? 2 : 0,
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.05)
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: RadioListTile(
                          value: address,
                          groupValue: controller.selectedAddress.value,
                          onChanged: (value) => controller.setAddress(value!),
                          title: Text(
                            address.label ?? "error",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(address.fullAddress),
                          activeColor: AppColors.primary,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  // Navigate to add address (placeholder for now)
                  showAddressForm(context);
                  // Get.snackbar('Info', 'Add address feature coming soon');
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Address'),
              ),
            ],
          );
        },
      ),
      isActive: controller.currentStep.value >= 0,
      state: controller.currentStep.value > 0
          ? StepState.complete
          : StepState.editing,
    );
  }

  Step _buildPaymentStep(ThemeData theme) {
    return Step(
      title: const Text(_paymentStepTitle),
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
      state: controller.currentStep.value > 1
          ? StepState.complete
          : StepState.editing,
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
          onChanged: enabled
              ? (val) => controller.setPaymentMethod(val.toString())
              : null,
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: enabled ? null : Colors.grey,
            ),
          ),
          subtitle: subtitle != null ? Text(subtitle) : null,
          secondary: Icon(
            icon,
            color: enabled ? AppColors.primary : Colors.grey,
          ),
          activeColor: AppColors.primary,
        ),
      );
    });
  }

  Step _buildReviewStep(ThemeData theme) {
    final cartController = Get.find<CartController>();

    return Step(
      title: const Text(_reviewStepTitle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            addRepaintBoundaries: true,
            itemCount: cartController.cartItems.length,
            itemBuilder: (context, index) {
              final item = cartController.cartItems[index];
              return ListTile(
                leading: CachedNetworkImage(
                  cacheManager: CustomCacheManager.instance,
                  imageUrl: item.product.imageUrls.first,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  memCacheWidth: 50,
                  memCacheHeight: 50,
                  errorWidget: (_, __, ___) => const Icon(Icons.image),
                ),
                title: Text(item.product.name),
                subtitle: Text(
                  '${item.quantity} x LE ${item.product.effectivePrice}',
                ),
                trailing: Text(
                  'LE ${(item.product.effectivePrice * item.quantity).toStringAsFixed(2)}',
                ),
              );
            },
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'LE ${cartController.totalPrice.toStringAsFixed(2)}',
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
            const Text(
              'Shipping To:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(controller.selectedAddress.value!.fullAddress),
          ],
          const SizedBox(height: 8),
          const Text(
            'Payment Method:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            controller.selectedPaymentMethod.value == 'cod'
                ? 'Cash on Delivery'
                : 'Credit Card',
          ),
          const SizedBox(height: 8),
          // notes
          const Text('Notes:', style: TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 8),

          TextField(
            controller: cartController.notesController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter any additional notes',
            ),
          ),
        ],
      ),
      isActive: controller.currentStep.value >= 2,
      state: StepState.editing,
    );
  }
}
