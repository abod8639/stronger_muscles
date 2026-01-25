import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';

final controller = Get.find<CartController>();

/// Handles the decrease quantity action
void handleDecrease(BuildContext context, ProductModel item) {
  final cartItem = controller.getCartItem(item);
  if (cartItem != null && cartItem.quantity > 1) {
    controller.decreaseQuantity(cartItem);
  } else {
    // Show confirmation before removing the last item
    showRemoveConfirmation(context, item);
  }
}

/// Shows a confirmation dialog before removing the item from cart
void showRemoveConfirmation(BuildContext context, ProductModel item) {
  // Immediately remove the item from the cart
  controller.decreaseQuantity(controller.getCartItem(item)!);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${item.name} removed from cart.'),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'UNDO',
        textColor: AppColors.primary,
        onPressed: () {
          controller.addToCart(item);
        },
      ),
    ),
  );
}
