import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';

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
    final theme = Theme.of(context);
    return Positioned(
      bottom: 10.0,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          product.imageUrls.length,
          (index) {
            final isActive = selectedImageIndex == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              height: 4.0,
              width: isActive ? 16.0 : 4.0,
              decoration: BoxDecoration(
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withAlpha(100),
                borderRadius: BorderRadius.circular(2.0),
              ),
            );
          },
        ),
      ),
    );
  }
}
