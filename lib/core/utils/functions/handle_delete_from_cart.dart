import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';

/// Handles the decrease quantity action
void handleDecrease(BuildContext context, WidgetRef ref, ProductModel item) {
  final cartNotifier = ref.read(cartControllerProvider.notifier);
  final cartItem = cartNotifier.getCartItem(item);
  if (cartItem != null && cartItem.quantity > 1) {
    cartNotifier.decreaseQuantity(cartItem);
  } else {
    showRemoveConfirmation(context, ref, item);
  }
}

/// Shows a confirmation dialog before removing the item from cart
void showRemoveConfirmation(
  BuildContext context,
  WidgetRef ref,
  ProductModel item,
) {
  final cartNotifier = ref.read(cartControllerProvider.notifier);
  final cartItem = cartNotifier.getCartItem(item);

  if (cartItem != null) {
    cartNotifier.decreaseQuantity(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} removed from cart.'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppColors.primary,
          onPressed: () {
            cartNotifier.addToCart(item);
          },
        ),
      ),
    );
  }
}
