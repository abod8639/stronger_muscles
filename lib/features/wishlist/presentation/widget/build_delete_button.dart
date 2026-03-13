import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/core/utils/functions/handle_delete_from_wishlist.dart';

const double _iconSize = 28.0;

class DeleteButtonFromWishlist extends ConsumerWidget {
  final ProductModel product;
  const DeleteButtonFromWishlist({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      label: 'Remove ${product.getLocalizedName(locale: 'en')} from wishlist',
      button: true,
      child: IconButton(
        icon: const Icon(
          Icons.delete_outline_rounded,
          size: _iconSize,
          color: AppColors.primary,
        ),
        onPressed: () => handleDeleteFromWishlist(context, ref, product),
        tooltip: 'Remove from Wishlist',
        splashRadius: 24.0,
      ),
    );
  }
}
