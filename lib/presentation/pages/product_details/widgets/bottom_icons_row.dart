import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/cart_item_model.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/presentation/controllers/product_details_controller.dart';

// Constants
const double _horizontalPadding = 16.0;
const double _verticalPadding = 8.0;
const double _buttonVerticalPadding = 12.0;
const double _buttonFontSize = 16.0;
const double _quantityFontSize = 18.0;
const double _spacing = 12.0;
const double _iconButtonSize = 32.0;

class BottomIconsRow extends StatelessWidget {
  final ProductModel product;

  const BottomIconsRow({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartController = Get.find<CartController>();
    final detailsController = Get.find<ProductDetailsController>();
    final l10n = AppLocalizations.of(context)!;

    return BottomAppBar(
      elevation: 10.0,
      height: 85, // تحديد ارتفاع مناسب
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        child: Row(
          children: [
            // Cart Action Area
            Expanded(
              child: Obx(() {
                final selectedFlavor = detailsController.selectedFlavor.value;
                final selectedSize = detailsController.selectedSize.value;

                final item = cartController.getCartItem(
                  product,
                  selectedFlavor: selectedFlavor,
                  selectedSize: selectedSize,
                );

                return item != null
                    ? _buildQuantityControls(
                        context,
                        theme,
                        cartController,
                        item,
                      )
                    : _buildAddToCartButton(
                        context,
                        detailsController,
                        cartController,
                        l10n,
                      );
              }),
            ),

            const SizedBox(width: _spacing),

            // Wishlist Button
            Obx(() => _buildWishlistButton(theme, detailsController)),
          ],
        ),
      ),
    );
  }

  /// زر إضافة للسلة
  Widget _buildAddToCartButton(
    BuildContext context,
    ProductDetailsController detailsController,
    CartController cartController,
    AppLocalizations l10n,
  ) {
    return ElevatedButton.icon(
      onPressed: () {
        cartController.addToCart(
          product,
          selectedFlavor: detailsController.selectedFlavor.value,
          selectedSize: detailsController.selectedSize.value,
        );
      },
      icon: const Icon(Icons.add_shopping_cart, size: 20),
      label: Text(l10n.addToCart),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: _buttonVerticalPadding),
        textStyle: const TextStyle(
          fontSize: _buttonFontSize,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  /// متحكم الكمية (عندما يكون المنتج في السلة)
  Widget _buildQuantityControls(
    BuildContext context,
    ThemeData theme,
    CartController cartController,
    CartItemModel item,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(
              item.quantity > 1
                  ? Icons.remove_circle_outline
                  : Icons.delete_outline_rounded,
              color: item.quantity > 1 ? AppColors.primary : Colors.redAccent,
            ),
            onPressed: () => cartController.decreaseQuantity(item),
            iconSize: _iconButtonSize,
            tooltip: item.quantity > 1
                ? l10n.decreaseQuantity
                : l10n.removeFromCart,
          ),
          Text(
            item.quantity.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: _quantityFontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColors.primary,
            ),
            onPressed: () => cartController.increaseQuantity(item),
            iconSize: _iconButtonSize,
            // tooltip: l10n.increaseQuantity,
          ),
        ],
      ),
    );
  }

  /// زر المفضلة
  Widget _buildWishlistButton(
    ThemeData theme,
    ProductDetailsController controller,
  ) {
    final isInWishlist = controller.isInWishlist.value;

    return Container(
      decoration: BoxDecoration(
        color: isInWishlist
            ? AppColors.primary.withOpacity(0.1)
            : theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: IconButton(
        icon: Icon(
          isInWishlist ? Icons.favorite : Icons.favorite_outline,
          color: isInWishlist
              ? AppColors.primary
              : theme.colorScheme.onSurfaceVariant,
          size: 28,
        ),
        onPressed: () => controller.toggleWishlist(),
      ),
    );
  }
}
