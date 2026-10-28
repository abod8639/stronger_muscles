import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';

/// Product carousel image indicator delegating to unified [AppDotsIndicator] with safe clamping.
class ImageIndicators extends StatelessWidget {
  const ImageIndicators({
    super.key,
    this.product,
    this.itemCount,
    required this.selectedImageIndex,
  });

  final dynamic product;
  final int? itemCount;
  final int selectedImageIndex;

  @override
  Widget build(BuildContext context) {
    final count = itemCount ?? (product?.imageUrls?.length as int? ?? 0);
    if (count <= 1) return const SizedBox.shrink();

    final safeIndex = selectedImageIndex.clamp(0, count - 1);

    return Positioned(
      bottom: 10.0,
      left: 0,
      right: 0,
      child: AppDotsIndicator(
        itemCount: count,
        currentIndex: safeIndex,
      ),
    );
  }
}
