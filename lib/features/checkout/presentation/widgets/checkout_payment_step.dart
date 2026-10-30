import 'package:flutter/material.dart';
import '../../../../core/components/components.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'payment_option_card.dart';

/// Step 2: choose the payment method.
class CheckoutPaymentStep extends StatelessWidget {
  const CheckoutPaymentStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSectionTitle(
          title: l10n.paymentMethod,
          padding: const EdgeInsets.only(bottom: AppDimens.spacingSm),
        ),
        PaymentOptionCard(
          value: 'cash',
          title: l10n.cashOnDelivery,
          icon: Icons.payments_outlined,
        ),
        const SizedBox(height: AppDimens.spacingSm),
        PaymentOptionCard(
          value: 'card',
          title: l10n.creditCardOrOnline,
          icon: Icons.credit_card_outlined,
          subtitle: l10n.paySecurelyStripe,
        ),
        const SizedBox(height: AppDimens.spacingLg),
        const AppSecureBadge(),
      ],
    );
  }
}
