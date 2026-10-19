import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles/core/utils/functions/app_guard.dart';
import 'package:stronger_muscles/features/checkout/presentation/controllers/checkout_controller.dart';
import 'package:stronger_muscles/features/checkout/presentation/widgets/checkout_steps.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

const double _controlsPadding = 20.0;
const double _controlsSpacing = 12.0;

class CheckoutView extends ConsumerWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutControllerProvider);
    final checkoutNotifier = ref.watch(checkoutControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: baseAppBar(context, l10n.checkout),
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
                        child: AppPrimaryButton(
                          text: checkoutState.currentStep == 2
                              ? l10n.placeOrder
                              : l10n.next,
                          onPressed: details.onStepContinue,
                          height: 48.0,
                        ),
                      ),
                      if (checkoutState.currentStep > 0) ...[
                        const SizedBox(width: _controlsSpacing),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: details.onStepCancel,
                            style: OutlinedButton.styleFrom(
                              shape: AppRadius.shapeMd,
                              minimumSize: const Size.fromHeight(48.0),
                            ),
                            child: Text(
                              l10n.back,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
              steps: [
                buildAddressStep(ref, l10n.address),
                buildPaymentStep(ref, l10n.payment),
                buildReviewStep(ref, l10n.review),
              ],
            ),
    );
  }
}
