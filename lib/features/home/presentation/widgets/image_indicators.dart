import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';

/// Product carousel image indicator delegating to unified [AppDotsIndicator] with safe clamping.
class ImageIndicators extends StatelessWidget {
  const ImageIndicators({
    super.key,
    required this.product,
    required this.selectedImageIndex,
  });

  final ProductModel product;
  final int selectedImageIndex;

  @override
  Widget build(BuildContext context) {
    if (product.imageUrls.isEmpty) return const SizedBox.shrink();

    final safeIndex = selectedImageIndex.clamp(0, product.imageUrls.length - 1);

    return Positioned(
      bottom: 10.0,
      left: 0,
      right: 0,
      child: AppDotsIndicator(
        itemCount: product.imageUrls.length,
        currentIndex: safeIndex,
      ),
    );
  }
}
