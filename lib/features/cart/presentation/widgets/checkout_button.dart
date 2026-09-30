import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/functions/handle_checkout.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

const double _checkoutButtonFontSize = 18.0;

class CheckoutButton extends ConsumerWidget {
  const CheckoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Semantics(
      label: localizations.proceedToCheckout,
      button: true,
      child: ElevatedButton(
        onPressed: () => handleCheckout(ref),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
          disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spacingXl,
            vertical: AppDimens.spacingLg,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimens.borderRadiusMd,
          ),
          elevation: AppDimens.elevationSm,
        ),
        child: Text(
          localizations.checkout,
          style: const TextStyle(
            fontSize: _checkoutButtonFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
