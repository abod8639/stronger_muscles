import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/functions/app_guard.dart';
import 'package:stronger_muscles/functions/build_payment_step.dart';
import 'package:stronger_muscles/functions/cache_manager.dart';
import 'package:stronger_muscles/functions/show_address_form.dart';
import 'package:stronger_muscles/presentation/controllers/checkout_controller.dart';
import 'package:stronger_muscles/presentation/controllers/profile_controller.dart';
import 'package:stronger_muscles/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/presentation/pages/cart/widgets/build_address_step.dart';
import 'package:stronger_muscles/presentation/pages/cart/widgets/build_review_step.dart';

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
            buildAddressStep(_addressStepTitle),
            buildPaymentStep(_paymentStepTitle),
            buildReviewStep(_reviewStepTitle),
          ],
        );
      }),
    );
  }
}
  Widget buildPaymentOption({
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
