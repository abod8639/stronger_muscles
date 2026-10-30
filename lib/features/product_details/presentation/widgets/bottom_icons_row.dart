import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/cart/cart_feature.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/product_details/presentation/controllers/product_details_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Sticky product actions: add to cart (or quantity controls once in the
/// cart) and the wishlist toggle.
class BottomIconsRow extends ConsumerWidget {
  static const double _height = 52.0;

  final ProductModel product;
  final String? initialFlavor;
  final String? initialSize;

  const BottomIconsRow({
    super.key,
    required this.product,
    this.initialFlavor,
    this.initialSize,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = productDetailsControllerProvider(
      product,
      initialFlavor: initialFlavor,
      initialSize: initialSize,
    );
    final detailsState = ref.watch(provider);
    final detailsNotifier = ref.read(provider.notifier);
    // Rebuild when the cart changes so the add button swaps to quantity controls.
    ref.watch(cartControllerProvider);
    final cartNotifier = ref.read(cartControllerProvider.notifier);
    final selectedFlavor = detailsState.selectedFlavor;
    final selectedSize = detailsState.selectedSizeObject?.size;
    final isInCart = cartNotifier.getCartItem(
          product.id,
          selectedFlavor: selectedFlavor,
          selectedSize: selectedSize,
        ) !=
        null;

    return AppBottomActionBar(
      child: Row(
        children: [
          Expanded(
            child: isInCart
                ? SizedBox(
                    height: _height,
                    child: CartQuantityControls(
                      product: product,
                      selectedFlavor: selectedFlavor,
                      selectedSize: selectedSize,
                      axis: Axis.horizontal,
                      iconSize: 30.0,
                      quantityFontSize: 18.0,
                    ),
                  )
                : _AddToCartButton(
                    product: product,
                    isPriceZero: detailsState.isPriceZero,
                    isMutating: cartNotifier.isMutating,
                    onAdd: () => cartNotifier.addToCart(
                      product.toEntity(),
                      selectedFlavor: selectedFlavor,
                      selectedSize: selectedSize,
                    ),
                  ),
          ),
          const SizedBox(width: AppDimens.spacingMd),
          _WishlistButton(
            isInWishlist: detailsState.isInWishlist,
            onPressed: () => detailsNotifier.toggleWishlist(product),
          ),
        ],
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  final ProductModel product;
  final bool isPriceZero;
  final bool isMutating;
  final VoidCallback onAdd;

  const _AddToCartButton({
    required this.product,
    required this.isPriceZero,
    required this.isMutating,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isOutOfStock = !product.isInStock;

    final (label, icon) = isOutOfStock
        ? (l10n.outOfStock, Icons.remove_shopping_cart_outlined)
        : isPriceZero
            ? (l10n.contactUs, Icons.mail_outline)
            : (l10n.addToCart, Icons.add_shopping_cart_rounded);

    return AppPrimaryButton(
      text: label,
      icon: icon,
      height: BottomIconsRow._height,
      isLoading: isMutating,
      backgroundColor: isOutOfStock || isPriceZero ? AppColors.greyDark : null,
      onPressed: isOutOfStock || isPriceZero ? null : onAdd,
    );
  }
}

class _WishlistButton extends StatelessWidget {
  final bool isInWishlist;
  final VoidCallback onPressed;

  const _WishlistButton({required this.isInWishlist, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        fixedSize: const Size.square(BottomIconsRow._height),
        shape: AppRadius.shapeLg,
        backgroundColor: isInWishlist
            ? AppColors.primary.withValues(alpha: 0.1)
            : context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      ),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
        child: Icon(
          isInWishlist ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
          key: ValueKey(isInWishlist),
          size: 26.0,
          color: isInWishlist ? AppColors.primary : context.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
