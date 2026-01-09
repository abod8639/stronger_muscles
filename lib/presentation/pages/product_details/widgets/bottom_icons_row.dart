import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/cart_item_model.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';
import 'package:stronger_muscles/presentation/bindings/product_details_controller.dart';

/// Bottom action bar for product details page with cart and wishlist actions
class BottomIconsRow extends StatelessWidget {
  // Constants for styling
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 8.0;
  static const double _iconSize = 32.0;
  static const double _buttonVerticalPadding = 10.0;
  static const double _buttonFontSize = 16.0;
  static const double _quantityFontSize = 18.0;
  static const double _spacing = 16.0;
  static const double _iconButtonSize = 40.0;

  final ProductModel product;

  const BottomIconsRow({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartController = Get.put(CartController());
    final productDetailsController = Get.find<ProductDetailsController>();

    return BottomAppBar(
      elevation: 8.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        child: Row(
          children: [
            // Cart Action (Add to Cart or Quantity Controls)
            Expanded(
              child: Obx(() => _buildCartAction(
                    context,
                    theme,
                    cartController,
                  )),
            ),

            const SizedBox(width: _spacing),

            // Wishlist Toggle Button
            Obx(() => _buildWishlistButton(
                  theme,
                  productDetailsController,
                )),
          ],
        ),
      ),
    );
  }

  /// Builds the cart action widget (either Add to Cart button or quantity controls)
  Widget _buildCartAction(
    BuildContext context,
    ThemeData theme,
    CartController cartController,
  ) {
    final productDetailsController = Get.find<ProductDetailsController>();
    final selectedFlavor = productDetailsController.selectedFlavor.value;
    
    final isInCart = cartController.isInCart(product, selectedFlavor: selectedFlavor);
    final CartItemModel? item =
        isInCart ? cartController.getCartItem(product, selectedFlavor: selectedFlavor) : null;
    
    return isInCart && item != null
        ? _buildQuantityControls(theme, cartController, item)
        : buildAddToCartButton(theme, cartController);
  }

  /// Builds the quantity control widget for items already in cart
  Widget _buildQuantityControls(
    ThemeData theme,
    CartController cartController,
    CartItemModel item,
  ) {
    return Builder(
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Decrease Button
              Semantics(
                label: item.quantity > 1
                    ? AppLocalizations.of(context)!.decreaseQuantity
                    : AppLocalizations.of(context)!.removeFromCart,
                button: true,
                child: IconButton(
                  icon: Icon(
                    item.quantity > 1
                        ? Icons.remove_circle_outline
                        : Icons.delete_outline_rounded,
                    color: AppColors.primary,
                  ),
                  onPressed: () => cartController.decreaseQuantity(item),
                  tooltip: item.quantity > 1 ? 'Decrease' : 'Remove',
                  iconSize: _iconButtonSize,
                ),
              ),
        
              // Quantity Display
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  item.quantity.toString(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: _quantityFontSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
        
              // Increase Button
              Semantics(
                label: 'Increase quantity',
                button: true,
                child: IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: AppColors.primary,
                  ),
                  onPressed: () => cartController.increaseQuantity(item),
                  tooltip: 'Increase',
                  iconSize: _iconButtonSize,
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  /// Builds the Add to Cart button
  Widget buildAddToCartButton(
    ThemeData theme,
    CartController cartController,
  ) {
    return Semantics(
      
      
      label: 'Add ${product.name} to cart',
      button: true,
      child: ElevatedButton.icon(
        
        onPressed: () => _handleAddToCart(cartController),
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Add to Cart'),
        
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: _buttonVerticalPadding),
          textStyle: const TextStyle(
            fontSize: _buttonFontSize,
            fontWeight: FontWeight.bold,
          ),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  /// Builds the wishlist toggle button
  Widget _buildWishlistButton(
    ThemeData theme,
    ProductDetailsController controller,
  ) {
    final isInWishlist = controller.isInWishlist.value;

    return Semantics(
      label: isInWishlist
          ? 'Remove ${product.name} from wishlist'
          : 'Add ${product.name} to wishlist',
      button: true,
      child: Container(
        decoration: BoxDecoration(
          color: isInWishlist
              ? AppColors.primary.withOpacity(0.1)
              : theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: IconButton(
          icon: Icon(
            isInWishlist ? Icons.favorite : Icons.favorite_outline,
            color: isInWishlist ? AppColors.primary : theme.colorScheme.onSurfaceVariant,
            size: _iconSize,
          ),
          onPressed: () => controller.toggleWishlist(),
          tooltip: isInWishlist ? 'Remove from Wishlist' : 'Add to Wishlist',
        ),
      ),
    );
  }

  /// Handles adding product to cart with feedback
  void _handleAddToCart(CartController cartController) {
    final productDetailsController = Get.find<ProductDetailsController>();
    cartController.addToCart(
      product,
      selectedFlavor: productDetailsController.selectedFlavor.value,
    );
  }


}

/// Legacy function for backward compatibility.
/// 
/// **Deprecated**: Use [BottomIconsRow] widget instead.
@Deprecated('Use BottomIconsRow widget instead')
Widget bottomIconsRow(ProductModel product) {
  final cartController = Get.find<CartController>();
  final productDetailsController = Get.put(ProductDetailsController(product));
  return Builder(builder: (context) {
    final theme = Theme.of(context);
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            
            Obx(() {
              final isInCart = cartController.isInCart(product);
              final CartItemModel? item =
                  isInCart ? cartController.getCartItem(product) : null;

              return Expanded(
                child: isInCart
                    ? Card(
                        color: theme.colorScheme.surface.withAlpha(
                          (255 * 0.1).round(),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () =>
                                    cartController.decreaseQuantity(item!),
                              ),
                              Text(
                                item!.quantity.toString(),
                                style: const TextStyle(fontSize: 18),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () =>
                                    cartController.increaseQuantity(item),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: () {
                          cartController.addToCart(product);
                          Get.snackbar(
                            duration: const Duration(seconds: 1),
                            AppLocalizations.of(context)!.addedToCart,
                            '${product.name} ${AppLocalizations.of(context)!.addedToCart}',
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: Text(AppLocalizations.of(context)!.addToCart),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              );
            }),

            const SizedBox(width: 16.0),

            Obx(() {
              return IconButton(
                icon: Icon(
                  productDetailsController.isInWishlist.value
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: productDetailsController.isInWishlist.value
                      ? theme.colorScheme.primary
                      : null,
                  size: 32,
                ),
                onPressed: () => productDetailsController.toggleWishlist(),
              );
            }
            
            ),
          ],
        ),
      ),
    );
  });
}
