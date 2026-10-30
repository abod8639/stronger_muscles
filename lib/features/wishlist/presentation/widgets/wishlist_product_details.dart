import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';

/// Displays brand, product name, effective price and original price (if discounted).
class WishlistProductDetails extends StatelessWidget {
  const WishlistProductDetails({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final productName = product.getLocalizedName(locale: Localizations.localeOf(context).languageCode);
    final brand = product.brand;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (brand != null && brand.isNotEmpty)
          Text(
            brand.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
            ),
          ),
        Text(
          productName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            height: 1.3,
            color: context.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppDimens.spacingSm),
        AppPriceText(
          price: product.baseEffectivePrice,
          originalPrice: product.hasDiscount ? product.price : null,
          direction: Axis.vertical,
        ),
      ],
    );
  }
}
