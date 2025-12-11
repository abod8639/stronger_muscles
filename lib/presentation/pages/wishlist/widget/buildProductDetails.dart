
import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

       const double titleFontSize = 18.0;
       const double priceFontSize = 16.0;
       const int maxTitleLines = 2;
/// Builds the product details section (name and price)
  Widget buildProductDetails(ProductModel product) {

    return Builder(
      builder: (context) {
    final theme = Theme.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Product Name
            Text(
              product.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: maxTitleLines,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8.0),
            
            // Product Price
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontSize: priceFontSize,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      }
    );
  }
