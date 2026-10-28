import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/checkout_button.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/total_price_section.dart';

const double _checkoutHorizontalPadding = 16.0;
const double _checkoutVerticalPadding = 12.0;
const double _spacing = 12.0;

/// Sticky bottom bar displaying total price summary and the checkout CTA button.
class CartCheckoutBottomBar extends StatelessWidget {
  const CartCheckoutBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _checkoutHorizontalPadding,
        vertical: _checkoutVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: context.topBarShadow,
      ),
      child: const SafeArea(
        child: Row(
          children: [
            TotalPriceSection(),
            SizedBox(width: _spacing),
            CheckoutButton(),
          ],
        ),
      ),
    );
  }
}
