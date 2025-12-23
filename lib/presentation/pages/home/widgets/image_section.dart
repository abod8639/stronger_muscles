
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({
    super.key,
    required this.product,
    required PageController pageController,
  }) : _pageController = pageController;

  final ProductModel product;
  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
        child: Container(
          width: double.maxFinite,
          color: theme
              .colorScheme
              .surfaceContainerLowest, // Slight background for image
          child: PageView.builder(
            controller: _pageController,
            itemCount: product.imageUrl.length,

            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(
                  8.0,
                ), // Padding for the image inside
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl[index],
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.broken_image_outlined,
                    color: theme.colorScheme.error,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
