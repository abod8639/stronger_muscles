import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

/// Builds the product price text
Widget buildProductPrice(ProductModel product) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      return Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'LE ${product.effectivePrice.toStringAsFixed(2)}',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (product.hasDiscount)
            Text(
              'LE ${product.price.toStringAsFixed(2)}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
        ],
      );
    },
  );
}
