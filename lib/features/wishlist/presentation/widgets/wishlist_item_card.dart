import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/app_card.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/wishlist/presentation/widgets/wishlist_delete_button.dart';
import 'package:stronger_muscles/features/wishlist/presentation/widgets/wishlist_product_details.dart';
import 'package:stronger_muscles/features/wishlist/presentation/widgets/wishlist_product_image.dart';
import 'package:stronger_muscles/routes/routes.dart';

class WishlistItemCard extends StatelessWidget {
  final ProductEntity product;

  const WishlistItemCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      borderRadius: AppRadius.allMd,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacingLg,
        vertical: AppDimens.spacingSm,
      ),
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      onTap: () => context.push(AppRoutes.productDetails, extra: product),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WishlistProductImage(product: product),
          const SizedBox(width: AppDimens.spacingLg),
          Expanded(child: WishlistProductDetails(product: product)),
          WishlistDeleteButton(product: product),
        ],
      ),
    );
  }
}

