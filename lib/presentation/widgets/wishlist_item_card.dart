import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/wishlist_controller.dart';
import 'package:stronger_muscles/presentation/pages/product_details/product_details_view.dart';
import 'package:stronger_muscles/presentation/widgets/buildDeleteButton.dart';
import 'package:stronger_muscles/presentation/widgets/buildProductDetails.dart';
import 'package:stronger_muscles/presentation/widgets/buildProductImage.dart';

class WishlistItemCard extends StatelessWidget {
  // Constants for consistent sizing and spacing
  static const double _borderRadius = 12.0;
  static const double _cardElevation = 2.0;
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 8.0;
  static const double _contentPadding = 12.0;
  static const double _spacing = 16.0;

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
              buildProductImage(product),

              const SizedBox(width: _spacing),

              // Product Details
              Expanded(child: buildProductDetails(product)),

              // Delete Button
              buildDeleteButtonFromWishlist(product),
            ],
          ),
        ),
      ),
    );
  }
}

/// Handles the delete action with optional confirmation
void handleDeleteFromWishlist(BuildContext context, ProductModel product) {
  final controller = Get.find<WishlistController>();

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
