import 'package:flutter/material.dart';
import 'package:stronger_muscles/presentation/pages/cart/widgets/checkout_button.dart';
import 'package:stronger_muscles/presentation/pages/cart/widgets/total_price_section.dart';

const double _checkoutHorizontalPadding = 16.0;
const double _checkoutVerticalPadding = 12.0;
const double _spacing = 12.0;

/// Builds the checkout section with total and checkout button
Widget buildCheckoutSection() {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: _checkoutHorizontalPadding,
          vertical: _checkoutVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10.0,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Total price section
              totalPriceSection(),

              const SizedBox(width: _spacing),

              // Checkout button
              checkoutButton(),
            ],
          ),
        ),
      );
    },
  );
}
