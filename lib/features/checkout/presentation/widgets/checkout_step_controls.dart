import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/components/components.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../controllers/checkout_controller.dart';

/// Sticky Back / Next (or Place order) controls for the checkout steps.
class CheckoutStepControls extends ConsumerWidget {
  static const int lastStep = 2;
  static const double _buttonHeight = 52.0;

  const CheckoutStepControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentStep = ref.watch(checkoutControllerProvider.select((s) => s.currentStep));
    final isProcessing = ref.watch(checkoutControllerProvider.select((s) => s.isProcessing));
    final hasAddress = ref.watch(
      checkoutControllerProvider.select((s) => s.selectedAddress != null),
    );
    final notifier = ref.read(checkoutControllerProvider.notifier);
    final isLastStep = currentStep == lastStep;
    final canContinue = !isProcessing && (currentStep != 0 || hasAddress);

    return AppBottomActionBar(
      child: Row(
        children: [
          if (currentStep > 0) ...[
            Expanded(
              child: AppSocialButton(
                icon: const Icon(Icons.arrow_back_rounded, size: AppDimens.iconSm),
                label: l10n.back,
                height: _buttonHeight,
                onPressed: isProcessing ? null : notifier.previousStep,
              ),
            ),
            const SizedBox(width: AppDimens.spacingMd),
          ],
          Expanded(
            flex: 2,
            child: AppPrimaryButton(
              text: isLastStep ? l10n.placeOrder : l10n.next,
              icon: isLastStep ? Icons.check_circle_outline_rounded : Icons.arrow_forward_rounded,
              height: _buttonHeight,
              isLoading: isProcessing,
              onPressed: !canContinue
                  ? null
                  : (isLastStep ? notifier.placeOrder : notifier.nextStep),
            ),
          ),
        ],
      ),
    );
  }
}
