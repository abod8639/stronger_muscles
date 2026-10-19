import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';

const double _imageSize = 85.0;

/// Reusable widget for cart product image with caching and unified border radius.
class CartItemImage extends StatelessWidget {
  final CartItemEntity item;

  const CartItemImage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.primaryImageUrl ??
        (item.product.imageUrls.isNotEmpty
            ? item.product.imageUrls.first.thumbnail
            : '');

    return Hero(
      tag: 'cart_product_${item.id}',
      child: ClipRRect(
        borderRadius: AppRadius.allMd,
        child: imageUrl.isNotEmpty
            ? CachedNetworkImage(
                cacheManager: CustomCacheManager.instance,
                imageUrl: imageUrl,
                width: _imageSize,
                height: _imageSize,
                fit: BoxFit.cover,
                memCacheWidth: 120,
                memCacheHeight: 120,
                placeholder: (ctx, url) => _buildPlaceholder(ctx),
                errorWidget: (ctx, url, error) => _buildErrorWidget(ctx),
              )
            : _buildErrorWidget(null),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: _imageSize,
      height: _imageSize,
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
      width: _imageSize,
      height: _imageSize,
      color: context != null
          ? Theme.of(context).colorScheme.surfaceContainerHighest
          : Colors.grey.shade200,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.primary,
        size: 38.0,
      ),
    );
  }
}

/// Backward compatibility function
Widget buildProductCartImage(CartItemEntity item) => CartItemImage(item: item);
