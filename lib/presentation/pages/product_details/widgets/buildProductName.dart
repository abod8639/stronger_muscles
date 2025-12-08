  import 'package:flutter/material.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

/// Builds the product name text
  Widget buildProductName(ProductModel product, ThemeData theme) {
    return Text(
      product.name,
      style: theme.textTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
    );
  }