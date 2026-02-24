import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

/// Builds the product price text
Widget buildProductPrice(
  ProductModel product, {
  double? alternateEffectivePrice,
  double? alternateOriginalPrice,
  bool? alternateHasDiscount,
}) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final effectivePrice = alternateEffectivePrice ?? product.effectivePrice;
      final originalPrice = alternateOriginalPrice ?? product.price;
      final hasDiscount = alternateHasDiscount ?? product.hasDiscount;

      return Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'LE ${effectivePrice.toStringAsFixed(2)}',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (hasDiscount)
            Text(
              'LE ${originalPrice.toStringAsFixed(2)}',
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
