import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/components/components.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/error/error.dart';
import '../../../../core/theme/theme.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../checkout_routes.dart';
import '../../domain/entities/checkout_result_entity.dart';
import '../controllers/checkout_controller.dart';
import '../widgets/checkout_steps.dart';

const double _controlsPadding = 20.0;
const double _controlsSpacing = 12.0;

class CheckoutView extends ConsumerWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(checkoutControllerProvider.select((s) => s.currentStep));
    final isProcessing = ref.watch(checkoutControllerProvider.select((s) => s.isProcessing));
    final hasError = ref.watch(checkoutControllerProvider.select((s) => s.hasError));
    final failure = ref.watch(checkoutControllerProvider.select((s) => s.failure));
    final checkoutNotifier = ref.read(checkoutControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Reactive listener for order placement completion or failure
    ref.listen<AsyncValue<CheckoutResultEntity?>>(
      checkoutControllerProvider.select((s) => s.orderSubmission),
      (previous, next) {
        next.whenOrNull(
          error: (error, _) {
            final message = error is Failure ? error.toMessage() : error.toString();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: l10n.retry,
                  textColor: Colors.white,
                  onPressed: () => checkoutNotifier.placeOrder(),
                ),
              ),
            );
          },
          data: (result) {
            if (result != null) {
              context.go(CheckoutRoutes.orderSuccess);
            }
          },
        );
      },
    );

    return Scaffold(
      appBar: baseAppBar(context, l10n.checkout),
      body: Column(
        children: [
          if (hasError) ...[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                borderRadius: AppRadius.allMd,
                border: Border.all(
                  color: theme.colorScheme.error.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: theme.colorScheme.error),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      failure?.toMessage() ?? l10n.failedToPlaceOrder,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18.0),
                    color: theme.colorScheme.error,
                    onPressed: checkoutNotifier.resetError,
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child: Stepper(
              type: StepperType.horizontal,
              currentStep: currentStep,
              onStepContinue: () {
                if (isProcessing) return;
                if (currentStep == 2) {
                  checkoutNotifier.placeOrder();
                } else {
                  checkoutNotifier.nextStep();
                }
              },
              onStepCancel: isProcessing ? null : checkoutNotifier.previousStep,
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: _controlsPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppPrimaryButton(
                          text: currentStep == 2
                              ? l10n.placeOrder
                              : l10n.next,
                          isLoading: isProcessing,
                          onPressed: isProcessing
                              ? null
                              : details.onStepContinue,
                          height: 48.0,
                        ),
                      ),
                      if (currentStep > 0) ...[
                        const SizedBox(width: _controlsSpacing),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isProcessing
                                ? null
                                : details.onStepCancel,
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
          ),
        ],
      ),
    );
  }
}
