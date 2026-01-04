import 'package:flutter/material.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/pages/product_details/widgets/show_reviews_list.dart';

/// Builds the reviews list section
/// Reviews are now fetched separately from a ReviewRepository
Widget buildShowReviewsListSection(ProductModel product) {
  if (product.reviewCount == 0) {
    return const SizedBox.shrink();
  }

  // TODO: Fetch reviews from ReviewRepository using product.id
  return ShowReviewsList(reviews: const []);
}