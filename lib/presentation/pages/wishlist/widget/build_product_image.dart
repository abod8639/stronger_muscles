import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/functions/cache_manager.dart';

Widget buildProductImage(ProductModel product) {
  const double imageSize = 100.0;
  const double imageBorderRadius = 8.0;

  final imageUrl = product.imageUrls.isNotEmpty ? product.imageUrls.first : '';

  return Builder(
    builder: (context) {
      return Hero(
        tag: 'wishlist_product_${product.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(imageBorderRadius),
          child: imageUrl.isNotEmpty
              ? CachedNetworkImage(
                cacheManager: CustomCacheManager.instance,
                  imageUrl: imageUrl,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: imageSize,
                    height: imageSize,
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2.0,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: imageSize,
                    height: imageSize,
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.primary,
                      size: 40.0,
                    ),
                  ),
                )
              : Container(
                  width: imageSize,
                  height: imageSize,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.primary,
                    size: 40.0,
                  ),
                ),
        ),
      );
    },
  );
}
