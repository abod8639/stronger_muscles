import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/checkout_button.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/total_price_section.dart';

const double _checkoutHorizontalPadding = 16.0;
const double _checkoutVerticalPadding = 12.0;
const double _spacing = 12.0;

class BuildCheckoutSection extends StatelessWidget {
  const BuildCheckoutSection({super.key});

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
