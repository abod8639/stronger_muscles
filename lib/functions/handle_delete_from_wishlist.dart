import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/controllers/wishlist_controller.dart';

// No global controller here

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
