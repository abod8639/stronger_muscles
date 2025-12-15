
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/functions/handleCheckout.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';


 const double _checkoutButtonPadding = 32.0;

 const double _checkoutButtonVerticalPadding = 16.0;

 const double _checkoutButtonFontSize = 18.0;

 const double _checkoutButtonRadius = 12.0;

 final controller = Get.find<CartController>();

Widget checkoutButton() {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);

        return Semantics(
          label: AppLocalizations.of(context)!.proceedToCheckout,
          button: true,
          child: ElevatedButton(
            onPressed: controller.cartItems.isEmpty
                ? null
                : () => handleCheckout(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              disabledBackgroundColor:
                  theme.colorScheme.surfaceContainerHighest,
              disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
              padding: const EdgeInsets.symmetric(
                horizontal: _checkoutButtonPadding,
                vertical: _checkoutButtonVerticalPadding,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_checkoutButtonRadius),
              ),
              elevation: 2.0,
            ),
            child: Text(
              AppLocalizations.of(context)!.checkout,
              style: TextStyle(
                fontSize: _checkoutButtonFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
