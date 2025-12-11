import 'package:flutter/material.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/ShowReviewsList.dart';

/// Builds the enhanced description section with expandable functionality
Widget buildShowReviewsListSection(ProductModel product) {
  if (product.reviews.isEmpty) {
    return const SizedBox.shrink();
  }

  return ShowReviewsList(reviews: product.reviews);
}