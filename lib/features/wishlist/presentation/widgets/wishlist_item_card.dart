import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/wishlist/presentation/widgets/wishlist_delete_button.dart';
import 'package:stronger_muscles/features/wishlist/presentation/widgets/wishlist_product_details.dart';
import 'package:stronger_muscles/features/wishlist/presentation/widgets/wishlist_product_image.dart';
import 'package:stronger_muscles/routes/routes.dart';

class WishlistItemCard extends StatelessWidget {
  final ProductModel product;

  const WishlistItemCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: colorScheme.surface,
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacingLg,
        vertical: AppDimens.spacingSm,
      ),
      elevation: AppDimens.elevationSm,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
      child: InkWell(
        onTap: () => context.push(AppRoutes.productDetails, extra: product),
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spacingMd),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WishlistProductImage(product: product),
              const SizedBox(width: AppDimens.spacingLg),
              Expanded(child: WishlistProductDetails(product: product)),
              WishlistDeleteButton(product: product),
            ],
          ),
        ),
      ),
    );
  }
}
