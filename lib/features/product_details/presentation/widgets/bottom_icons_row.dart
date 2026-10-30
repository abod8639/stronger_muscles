import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/app_quantity_controls.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';
import 'package:stronger_muscles/features/cart/cart_feature.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/product_details/presentation/controllers/product_details_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

const double _horizontalPadding = 16.0;
const double _verticalPadding = 8.0;
const double _buttonVerticalPadding = 12.0;
const double _buttonFontSize = 16.0;
const double _quantityFontSize = 18.0;
const double _spacing = AppDimens.spacingMd;
const double _iconButtonSize = 32.0;

class BottomIconsRow extends ConsumerWidget {
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
    final theme = Theme.of(context);

    final cartState = ref.watch(cartControllerProvider);
    final cartNotifier = ref.watch(cartControllerProvider.notifier);
    final detailsState = ref.watch(
      productDetailsControllerProvider(
        product,
        initialFlavor: initialFlavor,
        initialSize: initialSize,
      ),
    );
    final detailsNotifier = ref.watch(
      productDetailsControllerProvider(
        product,
        initialFlavor: initialFlavor,
        initialSize: initialSize,
      ).notifier,
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
                cartState,
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
    dynamic cartState,
  ) {
    final item = cartNotifier.getCartItem(
      product.id,
      selectedFlavor: detailsState.selectedFlavor,
      selectedSize: detailsState.selectedSizeObject?.size,
    );

    return item != null
        ? QuantityControls(
            product: product,
            selectedFlavor: detailsState.selectedFlavor,
            selectedSize: detailsState.selectedSizeObject?.size,
            axis: Axis.horizontal,
            iconSize: _iconButtonSize,
            quantityFontSize: _quantityFontSize,
          )
        : _buildAddToCartButton(
            detailsState,
            detailsNotifier,
            cartNotifier,
            l10n,
            cartState,
          );
  }

  Widget _buildAddToCartButton(
    ProductDetailsState detailsState,
    ProductDetailsController detailsNotifier,
    CartController cartNotifier,
    AppLocalizations l10n,
    dynamic cartState,
  ) {
    final isPriceZero = detailsState.isPriceZero;
    final isOutOfStock = !product.isInStock;
    final isMutating = cartNotifier.isMutating;
    final isDisabled = isPriceZero || isOutOfStock || isMutating;

    String buttonLabel;
    IconData buttonIcon;
    if (isOutOfStock) {
      buttonLabel = l10n.outOfStock;
      buttonIcon = Icons.remove_shopping_cart_outlined;
    } else if (isPriceZero) {
      buttonLabel = l10n.contactUs;
      buttonIcon = Icons.mail_outline;
    } else {
      buttonLabel = l10n.addToCart;
      buttonIcon = Icons.add_shopping_cart;
    }

    return ElevatedButton.icon(
      onPressed: isDisabled
          ? null
          : () {
              cartNotifier.addToCart(
                product.toEntity(),
                selectedFlavor: detailsState.selectedFlavor,
                selectedSize: detailsState.selectedSizeObject?.size,
              );
            },
      icon: isMutating
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(
              buttonIcon,
              size: 20,
            ),
      label: Text(buttonLabel),
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? Colors.grey : AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: _buttonVerticalPadding),
        textStyle: const TextStyle(
          fontSize: _buttonFontSize,
          fontWeight: FontWeight.bold,
        ),
        shape: AppRadius.shapeMd,
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
        borderRadius: AppRadius.allMd,
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
