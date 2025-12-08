  import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

/// Builds the product price text
  Widget buildProductPrice(ProductModel product, ThemeData theme) {
    return Text(
      'LE ${product.price.toStringAsFixed(2)}',
      style: theme.textTheme.headlineSmall?.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }