import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/product_details/presentation/controllers/product_reviews_controller.dart';
import 'package:stronger_muscles/features/product_details/presentation/widgets/expandable_description_card.dart';

/// Builds the enhanced description section with expandable functionality
Widget buildDescriptionSection(ProductModel product) {
  return Consumer(
    builder: (context, ref, child) {
      final locale = Localizations.localeOf(context).languageCode;
      final description = product.getLocalizedDescription(locale: locale);

      if (description.isEmpty) {
        return const SizedBox.shrink();
      }

      final reviewsAsync = ref.watch(productReviewsControllerProvider(product.id));
      final reviews = reviewsAsync.value?.map((e) => ReviewModel.fromEntity(e)).toList() ?? const [];

      return ExpandableDescriptionCard(
        description: description,
        reviews: reviews,
      );
    },
  );
}
