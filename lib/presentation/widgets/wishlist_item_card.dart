import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/wishlist_controller.dart';
import 'package:stronger_muscles/presentation/pages/product_details/product_details_view.dart';

class WishlistItemCard extends StatelessWidget {
  // Constants for consistent sizing and spacing
  static const double _imageSize = 100.0;
  static const double _borderRadius = 12.0;
  static const double _imageBorderRadius = 8.0;
  static const double _cardElevation = 2.0;
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 8.0;
  static const double _contentPadding = 12.0;
  static const double _spacing = 16.0;
  static const double _titleFontSize = 18.0;
  static const double _priceFontSize = 16.0;
  static const double _iconSize = 28.0;
  static const int _maxTitleLines = 2;

  final ProductModel product;
  final WishlistController controller;

  const WishlistItemCard({
    super.key,
    required this.product,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.surface,
      margin: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      elevation: _cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: InkWell(
        onTap: () => Get.to(
          () => ProductDetailsView(product: product),
          transition: Transition.fadeIn,
        ),
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(_contentPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Product Image with Hero Animation
              _buildProductImage(context),

              const SizedBox(width: _spacing),

              // Product Details
              Expanded(
                child: _buildProductDetails(context),
              ),

              // Delete Button
              _buildDeleteButton(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the product image with hero animation and error handling
  Widget _buildProductImage(BuildContext context) {
    final imageUrl = product.imageUrl.isNotEmpty 
        ? product.imageUrl.first 
        : '';

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
                  color: Theme.of(context).colorScheme.surfaceVariant,
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
                  color: Theme.of(context).colorScheme.surfaceVariant,
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
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.primary,
                  size: 40.0,
                ),
              ),
      ),
    );
  }

  /// Builds the product details section (name and price)
  Widget _buildProductDetails(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Product Name
        Text(
          product.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: _titleFontSize,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          maxLines: _maxTitleLines,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8.0),
        
        // Product Price
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: theme.textTheme.titleSmall?.copyWith(
            fontSize: _priceFontSize,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Builds the delete button with semantic label for accessibility
  Widget _buildDeleteButton(BuildContext context) {
    return Semantics(
      label: 'Remove ${product.name} from wishlist',
      button: true,
      child: IconButton(
        icon: const Icon(
          Icons.delete_outline_rounded,
          size: _iconSize,
          color: AppColors.primary,
        ),
        onPressed: () => _handleDelete(context),
        tooltip: 'Remove from Wishlist',
        splashRadius: 24.0,
      ),
    );
  }

  /// Handles the delete action with optional confirmation
  void _handleDelete(BuildContext context) {
    // Show a snackbar for undo functionality
    controller.removeFromWishlist(product);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} removed from wishlist'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppColors.primary,
          onPressed: () {
            controller.addToWishlist(product);
          },
        ),
      ),
    );
  }
}
