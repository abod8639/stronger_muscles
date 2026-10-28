import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';

/// Builds the product name text
Widget buildProductName(ProductModel product) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final locale = Localizations.localeOf(context).languageCode;
      return Text(
        product.getLocalizedName(locale: locale),
        style: theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      );
    },
  );
}
