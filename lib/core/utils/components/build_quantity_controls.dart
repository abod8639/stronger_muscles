import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/core/utils/functions/double_tap_prevention.dart';
import 'package:stronger_muscles/core/utils/functions/handle_delete_from_cart.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

const double _quantityFontSize = 16.0;
const double _iconSize = 28.0;

class QuantityControls extends ConsumerWidget {
  final ProductModel product;
  const QuantityControls({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final cartState = ref.watch(cartControllerProvider);
    final cartNotifier = ref.watch(cartControllerProvider.notifier);
    final item = cartNotifier.getCartItem(product);

    if (item == null) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final canIncrease =
        product.stockQuantity > 0 && item.quantity < product.stockQuantity;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .3),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            label:
                '${l10n.increaseQuantity}: ${item.product.getLocalizedName(locale: l10n.localeName)}',
            button: true,
            child: IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: canIncrease ? AppColors.primary : Colors.grey,
                size: _iconSize,
              ),
              onPressed: canIncrease
                  ? () => cartNotifier.increaseQuantity(item)
                  : null,
              tooltip: l10n.increaseQuantity,
              splashRadius: 20.0,
              padding: const EdgeInsets.all(4.0),
              constraints: const BoxConstraints(
                minWidth: 40.0,
                minHeight: 40.0,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
                ? '${l10n.decreaseQuantity}: ${item.product.getLocalizedName(locale: l10n.localeName)}'
                : '${l10n.removeFromCart}: ${item.product.getLocalizedName(locale: l10n.localeName)}',
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
              tooltip: item.quantity > 1
                  ? l10n.decreaseQuantity
                  : l10n.removeFromCart,
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
