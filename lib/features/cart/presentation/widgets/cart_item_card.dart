import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/cart_item_details.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/cart_quantity_controls.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Card representing a single product in the shopping cart.
class CartItemCard extends StatelessWidget {
  static const double _imageSize = 96.0;

  final CartItemEntity item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final product = item.product;
    final cacheSize = (_imageSize * MediaQuery.devicePixelRatioOf(context)).round();

    return AppCard(
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      borderRadius: AppRadius.allLg,
      onTap: () => context.push(
        AppRoutes.productDetails,
        extra: {
          'product': product,
          'selectedFlavor': item.selectedFlavor,
          'selectedSize': item.selectedSize,
        },
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'cart_product_${item.id}',
            child: AppNetworkImage(
              imageUrl: item.primaryImageUrl ??
                  (product.imageUrls.isNotEmpty ? product.imageUrls.first.thumbnail : null),
              width: _imageSize,
              height: _imageSize,
              memCacheWidth: cacheSize,
              memCacheHeight: cacheSize,
            ),
          ),
          const SizedBox(width: AppDimens.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CartItemDetails(item: item),
                const SizedBox(height: AppDimens.spacingSm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppPriceText(
                            price: product.baseEffectivePrice,
                            originalPrice:
                                product.baseHasDiscount ? product.basePrice : null,
                            direction: Axis.vertical,
                          ),
                          if (item.quantity > 1)
                            Text(
                              '${l10n.total}: ${AppPriceText.format(item.subtotal)}',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                    CartQuantityControls(
                      product: product,
                      selectedFlavor: item.selectedFlavor,
                      selectedSize: item.selectedSize,
                      axis: Axis.horizontal,
                      iconSize: 22.0,
                      quantityFontSize: 14.0,
                      borderRadius: AppRadius.allPill,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
