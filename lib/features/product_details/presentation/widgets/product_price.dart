import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Large product price with struck-through original, or "price on request"
/// when the price is zero.
class ProductPrice extends StatelessWidget {
  final double price;
  final double? originalPrice;

  const ProductPrice({super.key, required this.price, this.originalPrice});

  @override
  Widget build(BuildContext context) {
    if (price <= 0) {
      return Text(
        AppLocalizations.of(context)!.priceOnRequest,
        style: context.textTheme.headlineSmall?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return AppPriceText(price: price, originalPrice: originalPrice, fontSize: 22.0);
  }
}
