  import 'package:flutter/material.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

/// Builds the product name text
  Widget buildProductName(ProductModel product) {
    return Builder(
      builder: (context) {
    final theme = Theme.of(context);
        return Text(
      product.name,
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
        );
    }
    );
  }