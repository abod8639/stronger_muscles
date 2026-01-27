import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/cart_item_model.dart';
import 'package:stronger_muscles/functions/cache_manager.dart';

const double _imageSize = 100.0;
const double _imageBorderRadius = 8.0;

/// Builds the product image with hero animation and error handling
Widget buildProductCartImage(CartItemModel item) {
  final imageUrl = item.primaryImageUrl ?? '';

  return Hero(
    tag: 'cart_product_${item.id}',
    child: ClipRRect(
      borderRadius: BorderRadius.circular(_imageBorderRadius),
      child: imageUrl.isNotEmpty
          ? CachedNetworkImage(
              cacheManager: CustomCacheManager.instance,
              imageUrl: imageUrl,
              width: _imageSize,
              height: _imageSize,
              fit: BoxFit.cover,
              memCacheWidth: 120,
              memCacheHeight: 120,
              placeholder: (context, url) => _buildPlaceholder(context),
              errorWidget: (context, url, error) => _buildErrorWidget(context),
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
      size: 40.0,
    ),
  );
}
