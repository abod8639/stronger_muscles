
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class ImageIndicators extends StatelessWidget {
  const ImageIndicators({
    super.key,
    required this.product,
    required RxInt selectedImageIndex,
  }) : _selectedImageIndex = selectedImageIndex;

  final ProductModel product;
  final RxInt _selectedImageIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned(
      bottom: 10.0,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          product.imageUrl.length,
          (index) => Obx(() {
            final isActive = _selectedImageIndex.value == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(
                horizontal: 2.0,
              ),
              height: 4.0,
              width: isActive ? 16.0 : 4.0,
              decoration: BoxDecoration(
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface.withAlpha(100),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      ),
    );
  }
}

