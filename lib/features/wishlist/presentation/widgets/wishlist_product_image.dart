import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';

/// Displays the product thumbnail image with Hero animation for the wishlist.
class WishlistProductImage extends StatelessWidget {
  const WishlistProductImage({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.primaryImageUrl ??
        (product.imageUrls.isNotEmpty ? product.imageUrls.first.medium : null);

    return Hero(
      tag: 'wishlist_product_${product.id}',
      child: AppNetworkImage(
        imageUrl: imageUrl,
        width: AppDimens.thumbnailSize,
        height: AppDimens.thumbnailSize,
        borderRadius: AppRadius.allSm,
        memCacheWidth: 120,
        memCacheHeight: 120,
        errorIconSize: AppDimens.iconLg,
      ),
    );
  }
}
