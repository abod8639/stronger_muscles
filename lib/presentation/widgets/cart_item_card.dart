import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/cart_item_model.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';
import 'package:stronger_muscles/presentation/pages/product_details/product_details_view.dart';

class CartItemCard extends StatelessWidget {
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
  static const double _quantityFontSize = 16.0;
  static const double _iconSize = 28.0;
  static const int _maxTitleLines = 2;

  final CartItemModel item;
  final CartController controller;

  const CartItemCard({
    super.key,
    required this.item,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      elevation: _cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: InkWell(
        onTap: () => _navigateToProductDetails(),
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

              const SizedBox(width: 8.0),

              // Quantity Controls
              _buildQuantityControls(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the product image with hero animation and error handling
  Widget _buildProductImage(BuildContext context) {
    final imageUrl = item.imageUrl.isNotEmpty ? item.imageUrl.first : '';

    return Hero(
      tag: 'cart_product_${item.id}',
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
          item.name,
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
          '\$${item.price.toStringAsFixed(2)}',
          style: theme.textTheme.titleSmall?.copyWith(
            fontSize: _priceFontSize,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 4.0),

        // Total Price (if quantity > 1)
        if (item.quantity > 1)
          Text(
            'Total: \$${(item.price * item.quantity).toStringAsFixed(2)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

  /// Builds the quantity control buttons
  Widget _buildQuantityControls(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Increase Button
          Semantics(
            label: 'Increase quantity of ${item.name}',
            button: true,
            child: IconButton(
              icon: const Icon(
                Icons.add_circle_outline,
                color: AppColors.primary,
                size: _iconSize,
              ),
              onPressed: () => controller.increaseQuantity(item),
              tooltip: 'Increase',
              splashRadius: 20.0,
              padding: const EdgeInsets.all(4.0),
              constraints: const BoxConstraints(
                minWidth: 40.0,
                minHeight: 40.0,
              ),
            ),
          ),

          // Quantity Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              item.quantity.toString(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: _quantityFontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),

          // Decrease Button
          Semantics(
            label: item.quantity > 1
                ? 'Decrease quantity of ${item.name}'
                : 'Remove ${item.name} from cart',
            button: true,
            child: IconButton(
              icon: Icon(
                item.quantity > 1
                    ? Icons.remove_circle_outline
                    : Icons.delete_outline_rounded,
                color: AppColors.primary,
                size: _iconSize,
              ),
              onPressed: () => _handleDecrease(context),
              tooltip: item.quantity > 1 ? 'Decrease' : 'Remove',
              splashRadius: 20.0,
              padding: const EdgeInsets.all(4.0),
              constraints: const BoxConstraints(
                minWidth: 40.0,
                minHeight: 40.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Converts CartItemModel to ProductModel
  ProductModel _toProductModel() {
    return ProductModel(
      id: item.id,
      name: item.name,
      price: item.price,
      imageUrl: item.imageUrl,
      description: '',
    );
  }

  /// Navigates to product details page
  void _navigateToProductDetails() {
    Get.to(
      () => ProductDetailsView(product: _toProductModel()),
      transition: Transition.fadeIn,
    );
  }

  /// Handles the decrease quantity action
  void _handleDecrease(BuildContext context) {
    if (item.quantity > 1) {
      controller.decreaseQuantity(item);
    } else {
      // Show confirmation before removing the last item
      _showRemoveConfirmation(context);
    }
  }

  /// Shows a confirmation dialog before removing the item from cart
  void _showRemoveConfirmation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Remove ${item.name} from cart?'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'REMOVE',
          textColor: AppColors.primary,
          onPressed: () {
            controller.decreaseQuantity(item);
          },
        ),
      ),
    );
  }
}

