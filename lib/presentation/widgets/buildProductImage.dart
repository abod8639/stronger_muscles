  import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';



/// Builds the product image with hero animation and error handling
  Widget buildProductImage( ProductModel product) {

    const double _imageSize = 100.0;
    const double _imageBorderRadius = 8.0;

    final imageUrl = product.imageUrl.isNotEmpty 
        ? product.imageUrl.first 
        : '';

    return Builder(
      builder: (context) {
        return Hero(
          tag: 'wishlist_product_${product.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_imageBorderRadius),
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: _imageSize,
                    height: _imageSize,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: _imageSize,
                      height: _imageSize,
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2.0,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: _imageSize,
                      height: _imageSize,
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.primary,
                        size: 40.0,
                      ),
                    ),
                  )
                : Container(
                    width: _imageSize,
                    height: _imageSize,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.primary,
                      size: 40.0,
                    ),
                  ),
          ),
        );
      }
    );
  }
