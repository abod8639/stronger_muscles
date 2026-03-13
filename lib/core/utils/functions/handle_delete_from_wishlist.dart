import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/wishlist/presentation/controllers/wishlist_controller.dart';

void handleDeleteFromWishlist(
  BuildContext context,
  WidgetRef ref,
  ProductModel product,
) {
  final wishlistNotifier = ref.read(wishlistControllerProvider.notifier);

  wishlistNotifier.removeFromWishlist(product);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '${product.getLocalizedName(locale: 'en')} removed from wishlist',
      ),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'UNDO',
        textColor: AppColors.primary,
        onPressed: () {
          wishlistNotifier.addToWishlist(product);
        },
      ),
    ),
  );
}
