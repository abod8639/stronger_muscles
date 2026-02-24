import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

const double _titleFontSize = 18.0;
const double _priceFontSize = 16.0;
const int _maxTitleLines = 2;

Widget buildProductDetails(ProductModel product) {
  return Builder(
    builder: (context) {
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
          const SizedBox(height: 8.0),

          // Product Price
          Text(
            'LE ${product.effectivePrice.toStringAsFixed(2)}',
            style: theme.textTheme.titleSmall?.copyWith(
              fontSize: _priceFontSize,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Original price if on discount
          if (product.hasDiscount)
            Text(
              'LE ${product.price.toStringAsFixed(2)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
        ],
      );
    },
  );
}
