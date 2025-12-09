import 'package:flutter/material.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/ExpandableDescriptionCard.dart';

/// Builds the enhanced description section with expandable functionality
Widget buildDescriptionSection(ProductModel product, ThemeData theme) {
  if (product.description.isEmpty) {
    return const SizedBox.shrink();
  }

  return ExpandableDescriptionCard(
    description: product.description,
    theme: theme,
    reviews: product.reviews,
  );
}


