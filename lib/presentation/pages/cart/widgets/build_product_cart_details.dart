
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
            if (item.brand != null)
              Text(
                item.brand!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(height: 4.0),

            // Product Name
            Text(
              item.productName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: _titleFontSize,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: _maxTitleLines,
              overflow: TextOverflow.ellipsis,
            ),
            
            // Selected Flavor
            if (item.selectedFlavor != null && item.selectedFlavor!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${AppLocalizations.of(context)!.flavor}: ${item.selectedFlavor}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            
            const SizedBox(height: 8.0),
        
            // Product Price
            Text(
              '\$${item.price.toStringAsFixed(2)}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontSize: _priceFontSize,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
        
            const SizedBox(height: 4.0),
        
            // Total Price (if quantity > 1)
            if (item.quantity > 1)
              Text(
                'Total: \$${(item.price * item.quantity).toStringAsFixed(2)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        );
      }
    );
  }
