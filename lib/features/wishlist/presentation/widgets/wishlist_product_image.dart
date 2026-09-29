import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';

/// Displays the product thumbnail image with Hero animation for the wishlist.
class WishlistProductImage extends StatelessWidget {
  const WishlistProductImage({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.imageUrls.isNotEmpty
        ? product.imageUrls.first.medium
        : '';

    return Hero(
      tag: 'wishlist_product_${product.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        child: imageUrl.isNotEmpty
            ? CachedNetworkImage(
                cacheManager: CustomCacheManager.instance,
                imageUrl: imageUrl,
                width: AppDimens.thumbnailSize,
                height: AppDimens.thumbnailSize,
                fit: BoxFit.cover,
                memCacheWidth: 120,
                memCacheHeight: 120,
                placeholder: (context, url) => _buildPlaceholder(context),
                errorWidget: (context, url, error) =>
                    _buildErrorWidget(context),
              )
            : _buildErrorWidget(null),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: AppDimens.thumbnailSize,
      height: AppDimens.thumbnailSize,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2.0,
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext? context) {
    return Container(
      width: AppDimens.thumbnailSize,
      height: AppDimens.thumbnailSize,
      color: context != null
          ? Theme.of(context).colorScheme.surfaceContainerHighest
          : Colors.grey.shade200,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.primary,
        size: AppDimens.iconLg,
      ),
    );
  }
}
