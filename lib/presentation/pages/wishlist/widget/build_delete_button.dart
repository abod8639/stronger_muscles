
import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/functions/handle_delete_from_wishlist.dart';

/// Builds the delete button with semantic label for accessibility
  Widget buildDeleteButtonFromWishlist(ProductModel product) {
    const double iconSize = 28.0;

    return Builder(
      builder: (context) {
        return Semantics(
          label: 'Remove ${product.name} from wishlist',
          button: true,
          child: IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              size: iconSize,
              color: AppColors.primary,
            ),
            onPressed: () => handleDeleteFromWishlist(context, product),
            tooltip: 'Remove from Wishlist',
            splashRadius: 24.0,
          ),
        );
      }
    );
    
  }
