import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Handles the decrease quantity action with automatic removal prompt on quantity 1.
void handleDecrease(
  BuildContext context,
  WidgetRef ref,
  ProductEntity product, {
  String? selectedFlavor,
  String? selectedSize,
}) {
  final cartNotifier = ref.read(cartControllerProvider.notifier);
  final cartItem = cartNotifier.getCartItem(
    product.id,
    selectedFlavor: selectedFlavor,
    selectedSize: selectedSize,
  );

  if (cartItem != null && cartItem.quantity > 1) {
    cartNotifier.decreaseQuantity(cartItem);
  } else if (cartItem != null) {
    showRemoveConfirmation(context, ref, cartItem);
  }
}

/// Shows an undo-capable confirmation snackbar after removing an item from the cart.
void showRemoveConfirmation(
  BuildContext context,
  WidgetRef ref,
  CartItemEntity cartItem,
) {
  final cartNotifier = ref.read(cartControllerProvider.notifier);
  final l10n = AppLocalizations.of(context);

  cartNotifier.decreaseQuantity(cartItem);

  final String itemName = l10n != null
      ? cartItem.product.getLocalizedName(locale: l10n.localeName)
      : (cartItem.product.name?.en ?? '');

  final message = l10n != null
      ? '$itemName ${l10n.removedFromCart}'
      : '$itemName removed from cart.';
  final undoLabel = l10n?.undo ?? 'UNDO';

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: undoLabel,
        textColor: AppColors.primary,
        onPressed: () {
          cartNotifier.addToCart(
            cartItem.product,
            selectedFlavor: cartItem.selectedFlavor,
            selectedSize: cartItem.selectedSize,
            quantity: 1,
          );
        },
      ),
    ),
  );
}
