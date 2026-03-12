import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/expandable_description_card.dart';

/// Builds the enhanced description section with expandable functionality
Widget buildDescriptionSection(ProductModel product) {
  return Builder(
    builder: (context) {
      final locale = Localizations.localeOf(context).languageCode;
      final description = product.getLocalizedDescription(locale: locale);

      if (description.isEmpty) {
        return const SizedBox.shrink();
      }

      return ExpandableDescriptionCard(
        description: description,
        // Reviews are now fetched separately from a ReviewRepository
        reviews: const [],
      );
    },
  );
}
