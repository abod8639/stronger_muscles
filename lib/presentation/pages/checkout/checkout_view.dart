import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/functions/app_guard.dart';
import 'package:stronger_muscles/presentation/pages/checkout/widgets/build_payment_step.dart';
import 'package:stronger_muscles/presentation/controllers/checkout_controller.dart';
import 'package:stronger_muscles/presentation/pages/checkout/widgets/build_address_step.dart';
import 'package:stronger_muscles/presentation/pages/checkout/widgets/build_review_step.dart';

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
    Get.find<CheckoutController>();


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
