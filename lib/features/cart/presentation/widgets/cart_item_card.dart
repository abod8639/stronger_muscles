import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/components/app_card.dart';
import 'package:stronger_muscles/core/utils/components/build_quantity_controls.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/build_product_cart_details.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/build_product_cart_image.dart';
import 'package:stronger_muscles/routes/routes.dart';

class CartItemCard extends ConsumerWidget {
  final CartItemEntity item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AppCard(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacingLg,
        vertical: AppDimens.spacingSm,
      ),
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      borderRadius: AppDimens.borderRadiusLg,
      boxShadow: AppDimens.cardShadow(theme.shadowColor),
      onTap: () => context.push(
        AppRoutes.productDetails,
        extra: {
          'product': item.product,
          'selectedFlavor': item.selectedFlavor,
          'selectedSize': item.selectedSize,
        },
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Product Image
          buildProductCartImage(item),
          const SizedBox(width: AppDimens.spacingMd),

          // Product Details
          Expanded(
            child: buildProductCartDetails(item),
          ),
          const SizedBox(width: AppDimens.spacingSm),

          // Quantity Controls
          QuantityControls(
            product: item.product,
            selectedFlavor: item.selectedFlavor,
            selectedSize: item.selectedSize,
            axis: Axis.vertical,
            iconSize: 22.0,
            quantityFontSize: 14.0,
          ),
        ],
      ),
    );
  }
}
