import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/product_details_controller.dart';

/// Horizontal scrollable list of product image thumbnails
class ImageListView extends StatelessWidget {
  // Constants for styling
  static const double _listHeight = 100.0;
  static const double _thumbnailSize = 90.0;
  static const double _horizontalMargin = 8.0;
  static const double _padding = 4.0;
  static const double _borderWidth = 3.0;
  static const double _borderRadius = 8.0;
  static const Duration _animationDuration = Duration(milliseconds: 200);

  final ScrollController? scrollController;
  final ProductModel product;

  const ImageListView({
    super.key,
    this.scrollController,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductDetailsController>();

    // Don't show if there's only one image or no images
    if (product.imageUrl.length <= 1) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: _listHeight,
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: product.imageUrl.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => _buildThumbnail(
          controller,
          index,
        ),
      ),
    );
  }

  /// Builds a single thumbnail image
  Widget _buildThumbnail( ProductDetailsController controller,int index ) {

    return Semantics(
      label: 'Product image ${index + 1} of ${product.imageUrl.length}',
      button: true,
      child: GestureDetector(
        onTap: () => controller.selectImage(index),
        child: Obx(() {
          final isSelected = controller.selectedImageIndex.value == index;
          return AnimatedContainer(
            duration: _animationDuration,
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: _horizontalMargin),
            padding: const EdgeInsets.all(_padding),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : Colors.transparent,
                width: _borderWidth,
              ),
              borderRadius: BorderRadius.circular(_borderRadius),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8.0,
                        spreadRadius: 1.0,
                      ),
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_borderRadius - _padding),
              child: _buildThumbnailImage( index),
            ),
          );
        }),
      ),
    );
  }

  /// Builds the thumbnail image with error handling
  Widget _buildThumbnailImage( int index ) {

    final imageUrl = product.imageUrl[index];

    return Builder(
      builder: (context) {
    final theme = Theme.of(context);
        return CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          width: _thumbnailSize,
          height: _thumbnailSize,
          placeholder: (context, url) => Container(
            width: _thumbnailSize,
            height: _thumbnailSize,
            color: theme.colorScheme.surfaceContainerHighest,
            child: const Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        
          errorWidget: (context, url, error) => Container(
            width: _thumbnailSize,
            height: _thumbnailSize,
            color: theme.colorScheme.surfaceContainerHighest,
            child: const Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.primary,
              size: 32.0,
            ),
          ),
          
        );
      }
    );
  }
}
