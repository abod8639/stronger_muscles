import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/pages/wishlist/widget/build_delete_button.dart';
import 'package:stronger_muscles/presentation/pages/wishlist/widget/build_product_details.dart';
import 'package:stronger_muscles/presentation/pages/wishlist/widget/build_product_image.dart';
import 'package:stronger_muscles/routes/routes.dart';

class WishlistItemCard extends StatelessWidget {
  static const double _borderRadius = 12.0;
  static const double _cardElevation = 2.0;
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 8.0;
  static const double _contentPadding = 12.0;
  static const double _spacing = 16.0;

  final ProductModel product;

  const WishlistItemCard({super.key, required this.product});

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
        onTap: () => Get.toNamed(AppRoutes.productDetails, arguments: product),
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(_contentPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildProductImage(product),
              const SizedBox(width: _spacing),
              Expanded(child: buildProductDetails(product)),
              buildDeleteButtonFromWishlist(product),
            ],
          ),
        ),
      ),
    );
  }
}
