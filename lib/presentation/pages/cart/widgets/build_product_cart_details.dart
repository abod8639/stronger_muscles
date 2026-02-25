import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/cart_item_model.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

const double _titleFontSize = 18.0;

const double _priceFontSize = 16.0;

const int _maxTitleLines = 2;

/// Builds the product details section (name and price)
Widget buildProductCartDetails(CartItemModel item) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Brand
          if (item.product.brand != null)
            Text(
              item.product.brand!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: 4.0),

          // Product Name
          Text(
            item.product.getLocalizedName(locale: AppLocalizations.of(context)!.localeName ),
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: _titleFontSize,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: _maxTitleLines,
            overflow: TextOverflow.ellipsis,
            semanticsLabel: item.product.getLocalizedName(locale: AppLocalizations.of(context)!.localeName ),
          ),

          // Selected Flavor
          if (item.selectedFlavor != null && item.selectedFlavor!.isNotEmpty)
            selectedValue(
              title: AppLocalizations.of(context)!.flavor, 
              value: item.selectedFlavor!, 
              item: item,
              ),

          // Selected Size
          if (item.selectedSize != null && item.selectedSize!.isNotEmpty)
            selectedValue(
            title:  AppLocalizations.of(context)!.size,
            value: item.selectedSize!,
            item: item,
            ),

          const SizedBox(height: 8.0),

          // Product Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                '\$${item.product.baseEffectivePrice.toStringAsFixed(2)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: _priceFontSize,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Text(
                '\$${item.product.basePrice.toStringAsFixed(2)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: _priceFontSize,
                  color: AppColors.grey,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              SizedBox(width: 5),
            ],
          ),

          const SizedBox(height: 4.0),

          // Total Price (if quantity > 1)
          if (item.quantity > 1)
            Text(
              'Total: \$${item.subtotal.toStringAsFixed(2)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      );
    },
  );
}




Builder selectedValue({
  required String title,
  required String value,
  required CartItemModel item,
  Color? color,
  
}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      return Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Row(
          children: [
             
            Text(
              "$title: ",
              // '${AppLocalizations.of(context)!.flavor}: ',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),

            Text(
              value,
              // '${item.selectedFlavor}',
              style: theme.textTheme.bodySmall?.copyWith(
                color:color ?? AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    },
  );
}
