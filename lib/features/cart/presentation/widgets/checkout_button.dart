import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/features/cart/presentation/utils/handle_checkout.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Checkout CTA button in cart using [AppPrimaryButton].
class CheckoutButton extends ConsumerWidget {
  const CheckoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return Semantics(
      label: localizations.proceedToCheckout,
      button: true,
      child: AppPrimaryButton(
        text: localizations.checkout,
        icon: Icons.arrow_forward_rounded,
        height: 48.0,
        onPressed: () => handleCheckout(ref),
      ),
    );
  }
}
