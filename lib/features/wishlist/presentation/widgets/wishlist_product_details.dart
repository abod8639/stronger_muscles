import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';

/// Displays product name, effective price, and original price (if discounted).
class WishlistProductDetails extends StatelessWidget {
  const WishlistProductDetails({super.key, required this.product});

  static const double _titleFontSize = 18.0;
  static const double _priceFontSize = 16.0;
  static const int _maxTitleLines = 2;

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final productName = product.getLocalizedName(locale: locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Product Name
        Text(
          productName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: _titleFontSize,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          maxLines: _maxTitleLines,
          overflow: TextOverflow.ellipsis,
          semanticsLabel: productName,
        ),
        const SizedBox(height: AppDimens.spacingSm),

        // Product Price (with struck-through original if discounted)
        AppPriceText(
          price: product.baseEffectivePrice,
          originalPrice: product.hasDiscount ? product.price : null,
          fontSize: _priceFontSize,
          direction: Axis.vertical,
        ),
      ],
    );
  }
}
