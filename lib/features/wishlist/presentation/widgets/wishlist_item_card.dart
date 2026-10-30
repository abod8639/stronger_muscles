import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/app_card.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/wishlist/presentation/widgets/wishlist_delete_button.dart';
import 'package:stronger_muscles/features/wishlist/presentation/widgets/wishlist_product_details.dart';
import 'package:stronger_muscles/features/wishlist/presentation/widgets/wishlist_product_image.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Card widget displaying a wishlist product item.
class WishlistItemCard extends StatelessWidget {
  final ProductEntity product;

  const WishlistItemCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      onTap: () => context.push(AppRoutes.productDetails, extra: product),
      child: Row(
        children: [
          WishlistProductImage(product: product),
          const SizedBox(width: AppDimens.spacingMd),
          Expanded(child: WishlistProductDetails(product: product)),
          WishlistDeleteButton(product: product),
        ],
      ),
    );
  }
}
