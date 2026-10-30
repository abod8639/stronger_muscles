import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/components/components.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../payment/payment_feature.dart';
import '../controllers/checkout_controller.dart';

/// Step 2: choose the payment method.
class CheckoutPaymentStep extends ConsumerWidget {
  const CheckoutPaymentStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedMethod = ref.watch(
      checkoutControllerProvider.select((s) => s.selectedPaymentMethod),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionTitle(
          title: l10n.paymentMethod,
          padding: const EdgeInsets.only(bottom: AppDimens.spacingSm),
        ),
        PaymentMethodSelector(
          selectedMethodId: selectedMethod,
          onMethodSelected: ref.read(checkoutControllerProvider.notifier).setPaymentMethod,
          methods: [
            PaymentMethodEntity(
              id: 'cash',
              title: l10n.cashOnDelivery,
              icon: Icons.payments_outlined,
            ),
            PaymentMethodEntity(
              id: 'card',
              title: l10n.creditCardOrOnline,
              subtitle: l10n.paySecurelyStripe,
              icon: Icons.credit_card_outlined,
            ),
          ],
        ),
      ],
    );
  }
}
