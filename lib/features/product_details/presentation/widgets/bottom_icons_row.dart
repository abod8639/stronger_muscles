import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/cart/data/models/cart_item_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/product_details/presentation/controllers/product_details_controller.dart';

const double _horizontalPadding = 16.0;
const double _verticalPadding = 8.0;
const double _buttonVerticalPadding = 12.0;
const double _buttonFontSize = 16.0;
const double _quantityFontSize = 18.0;
const double _spacing = 12.0;
const double _iconButtonSize = 32.0;

class BottomIconsRow extends ConsumerWidget {
  final ProductModel product;

  const BottomIconsRow({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // final cartState = ref.watch(cartControllerProvider);
    final cartNotifier = ref.watch(cartControllerProvider.notifier);
    final detailsState = ref.watch(productDetailsControllerProvider(product));
    final detailsNotifier = ref.watch(
      productDetailsControllerProvider(product).notifier,
    );
    final l10n = AppLocalizations.of(context)!;

    return BottomAppBar(
      elevation: 10.0,
      height: 85,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildCartActionArea(
                context,
                ref,
                theme,
                cartNotifier,
                detailsState,
                detailsNotifier,
                l10n,
              ),
            ),
            const SizedBox(width: _spacing),
            _buildWishlistButton(theme, detailsState, detailsNotifier),
          ],
        ),
      ),
    );
  }

  Widget _buildCartActionArea(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    CartController cartNotifier,
    ProductDetailsState detailsState,
    ProductDetailsController detailsNotifier,
    AppLocalizations l10n,
  ) {
    final item = cartNotifier.getCartItem(
      product,
      selectedFlavor: detailsState.selectedFlavor,
      selectedSize: detailsState.selectedSizeObject?.size,
    );

    return item != null
        ? _buildQuantityControls(theme, cartNotifier, item, l10n)
        : _buildAddToCartButton(
            detailsState,
            detailsNotifier,
            cartNotifier,
            l10n,
          );
  }

  Widget _buildAddToCartButton(
    ProductDetailsState detailsState,
    ProductDetailsController detailsNotifier,
    CartController cartNotifier,
    AppLocalizations l10n,
  ) {
    final isPriceZero = detailsNotifier.getDisplayEffectivePrice(product) <= 0;

    return ElevatedButton.icon(
      onPressed: isPriceZero
          ? null
          : () {
              cartNotifier.addToCart(
                product,
                selectedFlavor: detailsState.selectedFlavor,
                selectedSize: detailsState.selectedSizeObject?.size,
              );
            },
      icon: Icon(
        isPriceZero ? Icons.mail_outline : Icons.add_shopping_cart,
        size: 20,
      ),
      label: Text(isPriceZero ? l10n.contactUs : l10n.addToCart),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPriceZero ? Colors.grey : AppColors.primary,
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

  Widget _buildQuantityControls(
    ThemeData theme,
    CartController cartNotifier,
    CartItemModel item,
    AppLocalizations l10n,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .4),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.primary.withValues(alpha: .2)),
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
            onPressed: () => cartNotifier.decreaseQuantity(item),
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
            onPressed: () => cartNotifier.increaseQuantity(item),
            iconSize: _iconButtonSize,
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistButton(
    ThemeData theme,
    ProductDetailsState detailsState,
    ProductDetailsController detailsNotifier,
  ) {
    final isInWishlist = detailsState.isInWishlist;

    return Container(
      decoration: BoxDecoration(
        color: isInWishlist
            ? AppColors.primary.withValues(alpha: .1)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: .4),
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
        onPressed: () => detailsNotifier.toggleWishlist(product),
      ),
    );
  }
}
