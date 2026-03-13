import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/utils/functions/app_guard.dart';
import 'package:stronger_muscles/features/checkout/presentation/controllers/checkout_controller.dart';
import 'package:stronger_muscles/features/checkout/presentation/widgets/checkout_steps.dart';

const String _checkoutTitle = 'Checkout';
const String _nextButtonText = 'Next';
const String _placeOrderButtonText = 'Place Order';
const String _backButtonText = 'Back';
const double _controlsPadding = 20.0;
const double _controlsSpacing = 12.0;
const double _controlsVerticalPadding = 12.0;

class CheckoutView extends ConsumerWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutControllerProvider);
    final checkoutNotifier = ref.watch(checkoutControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          _checkoutTitle,
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: checkoutState.isProcessing
          ? const Center(child: CircularProgressIndicator())
          : Stepper(
              type: StepperType.horizontal,
              currentStep: checkoutState.currentStep,
              onStepContinue: () {
                AppGuard.runSafe(ref, () async {
                  if (checkoutState.currentStep == 2) {
                    await checkoutNotifier.placeOrder(context);
                  } else {
                    checkoutNotifier.nextStep();
                  }
                });
              },
              onStepCancel: checkoutNotifier.previousStep,
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
                            padding: const EdgeInsets.symmetric(
                              vertical: _controlsVerticalPadding,
                            ),
                          ),
                          child: Text(
                            checkoutState.currentStep == 2
                                ? _placeOrderButtonText
                                : _nextButtonText,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      if (checkoutState.currentStep > 0) ...[
                        const SizedBox(width: _controlsSpacing),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: details.onStepCancel,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: _controlsVerticalPadding,
                              ),
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
                buildAddressStep(ref, 'Address'),
                buildPaymentStep(ref, 'Payment'),
                buildReviewStep(ref, 'Review'),
              ],
            ),
    );
  }
}
