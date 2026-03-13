import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/core/utils/functions/double_tap_prevention.dart';
import 'package:stronger_muscles/core/utils/functions/handle_delete_from_cart.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';

const double _quantityFontSize = 16.0;
const double _iconSize = 28.0;

class QuantityControls extends ConsumerWidget {
  final ProductModel product;
  const QuantityControls({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);
    final cartNotifier = ref.watch(cartControllerProvider.notifier);
    final item = cartNotifier.getCartItem(product);

    if (item == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: .3,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            label: 'Increase quantity of ${item.product.getLocalizedName(locale: 'en')}',
            button: true,
            child: IconButton(
              icon: const Icon(
                Icons.add_circle_outline,
                color: AppColors.primary,
                size: _iconSize,
              ),
              onPressed: () => cartNotifier.increaseQuantity(item),
              tooltip: 'Increase',
              splashRadius: 20.0,
              padding: const EdgeInsets.all(4.0),
              constraints: const BoxConstraints(
                minWidth: 40.0,
                minHeight: 40.0,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .1),
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
          Semantics(
            label: item.quantity > 1
                ? 'Decrease quantity of ${item.product.getLocalizedName(locale: 'en')}'
                : 'Remove ${item.product.getLocalizedName(locale: 'en')} from cart',
            button: true,
            child: IconButton(
              icon: Icon(
                item.quantity > 1
                    ? Icons.remove_circle_outline
                    : Icons.delete_outline_rounded,
                color: AppColors.primary,
                size: _iconSize,
              ),
              onPressed: () => doubleTapPrevention(
                () => showRemoveConfirmation(context, ref, product),
              ),
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
}
