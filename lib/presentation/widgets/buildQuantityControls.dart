
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/functions/doubleTapPrevention.dart';
import 'package:stronger_muscles/functions/handleDeleteFromCart.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';


   const double _quantityFontSize = 16.0;
   const double _iconSize = 28.0;
   final controller = Get.find<CartController>();

/// Builds the quantity control buttons
  Widget buildQuantityControls( ProductModel product) {

    return Obx(() {
      final item = controller.getCartItem(product);
      
      if (item == null) {
        return const SizedBox.shrink();
      }

      return Builder(
        builder: (context) {
      final theme = Theme.of(context);
          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Increase Button
                Semantics(
                  label: 'Increase quantity of ${item.productName}',
                  button: true,
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: AppColors.primary,
                      size: _iconSize,
                    ),
                    onPressed: () => controller.increaseQuantity(item),
                    tooltip: 'Increase',
                    splashRadius: 20.0,
                    padding: const EdgeInsets.all(4.0),
                    constraints: const BoxConstraints(
                      minWidth: 40.0,
                      minHeight: 40.0,
                    ),
                  ),
                ),
          
                // Quantity Display
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.0),
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
          
                // Decrease Button
                Semantics(
                  label: item.quantity > 1
                      ? 'Decrease quantity of ${item.productName}'
                      : 'Remove ${item.productName} from cart',
                  button: true,
                  child: IconButton(
                    icon: Icon(
                      item.quantity > 1
                          ? Icons.remove_circle_outline
                          : Icons.delete_outline_rounded,
                      color: AppColors.primary,
                      size: _iconSize,
                    ),
                    onPressed: () => doubleTapPrevention( () => showRemoveConfirmation(context, product)), 
                    tooltip: item.quantity > 1 ? 'Decrease' : 'Remove',
                    splashRadius: 20.0,
                    padding: const EdgeInsets.all(4.0),
                    constraints: const BoxConstraints(
                      minWidth: 40.0,
                      minHeight: 40.0,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      );
    });
  }
