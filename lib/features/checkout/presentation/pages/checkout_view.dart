import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/components/components.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../checkout_routes.dart';
import '../../domain/entities/checkout_result_entity.dart';
import '../controllers/checkout_controller.dart';
import '../widgets/checkout_address_step.dart';
import '../widgets/checkout_payment_step.dart';
import '../widgets/checkout_review_step.dart';
import '../widgets/checkout_step_controls.dart';

class CheckoutView extends ConsumerWidget {
  const CheckoutView({super.key});

  static const List<Widget> _steps = [
    CheckoutAddressStep(),
    CheckoutPaymentStep(),
    CheckoutReviewStep(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentStep = ref.watch(checkoutControllerProvider.select((s) => s.currentStep));
    final isProcessing = ref.watch(checkoutControllerProvider.select((s) => s.isProcessing));
    final failure = ref.watch(
      checkoutControllerProvider.select((s) => s.hasError ? s.orderSubmission.error : null),
    );
    final notifier = ref.read(checkoutControllerProvider.notifier);

    // Navigate once the order is placed; failures are shown inline by [AppErrorCard].
    ref.listen<AsyncValue<CheckoutResultEntity?>>(
      checkoutControllerProvider.select((s) => s.orderSubmission),
      (previous, next) {
        if (next.valueOrNull != null) {
          context.go(CheckoutRoutes.orderSuccess);
        }
      },
    );

    return PopScope(
      // System back walks back through the steps before leaving checkout.
      canPop: currentStep == 0 && !isProcessing,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !isProcessing) notifier.previousStep();
      },
      child: Scaffold(
        appBar: baseAppBar(context, l10n.checkout),
        bottomNavigationBar: const CheckoutStepControls(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.spacingLg,
                AppDimens.spacingLg,
                AppDimens.spacingLg,
                AppDimens.spacingSm,
              ),
              child: AppStepProgress(
                steps: [l10n.address, l10n.payment, l10n.review],
                activeIndex: currentStep,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: failure == null
                  ? const SizedBox(width: double.infinity)
                  : AppErrorCard(
                      error: failure,
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spacingLg,
                        vertical: AppDimens.spacingSm,
                      ),
                      onRetry: notifier.placeOrder,
                      onDismiss: notifier.resetError,
                    ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: SingleChildScrollView(
                  key: ValueKey(currentStep),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.all(AppDimens.spacingLg),
                  child: _steps[currentStep],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
