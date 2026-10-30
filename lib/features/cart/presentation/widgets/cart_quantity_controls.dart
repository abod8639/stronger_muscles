import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/app_radius.dart';
import 'package:stronger_muscles/core/utils/functions/double_tap_prevention.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/cart/presentation/utils/handle_delete_from_cart.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

const double _defaultQuantityFontSize = 16.0;
const double _defaultIconSize = 28.0;

/// +/- quantity stepper for an item already in the cart (decrease on the last
/// unit offers removal). Horizontal or vertical; renders nothing if not in cart.
class CartQuantityControls extends ConsumerWidget {
  final dynamic product;
  final String? selectedFlavor;
  final String? selectedSize;
  final Axis axis;
  final double iconSize;
  final double quantityFontSize;
  final BorderRadius? borderRadius;

  const CartQuantityControls({
    super.key,
    required this.product,
    this.selectedFlavor,
    this.selectedSize,
    this.axis = Axis.vertical,
    this.iconSize = _defaultIconSize,
    this.quantityFontSize = _defaultQuantityFontSize,
    this.borderRadius,
  });

  ProductEntity get _productEntity {
    if (product is ProductEntity) return product as ProductEntity;
    if (product is ProductModel) return (product as ProductModel).toEntity();
    throw ArgumentError(
      'Expected ProductEntity or ProductModel, but received: ${product.runtimeType}',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartNotifier = ref.watch(cartControllerProvider.notifier);
    final entity = _productEntity;
    final item = cartNotifier.getCartItem(
      entity.id,
      selectedFlavor: selectedFlavor,
      selectedSize: selectedSize,
    );

    if (item == null) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final canIncrease =
        entity.stockQuantity > 0 && item.quantity < entity.stockQuantity;

    final productName = entity.getLocalizedName(locale: l10n.localeName);

    final decreaseButton = Semantics(
      label: item.quantity > 1
          ? '${l10n.decreaseQuantity}: $productName'
          : '${l10n.removeFromCart}: $productName',
      button: true,
      child: IconButton(
        icon: Icon(
          item.quantity > 1
              ? Icons.remove_circle_outline
              : Icons.delete_outline_rounded,
          color: item.quantity > 1 ? AppColors.primary : AppColors.error,
          size: iconSize,
        ),
        onPressed: () => doubleTapPrevention(
          () => handleDecrease(
            context,
            ref,
            entity,
            selectedFlavor: selectedFlavor,
            selectedSize: selectedSize,
          ),
        ),
        tooltip:
            item.quantity > 1 ? l10n.decreaseQuantity : l10n.removeFromCart,
        splashRadius: 20.0,
        padding: const EdgeInsets.all(4.0),
        constraints: BoxConstraints(
          minWidth: iconSize + 8,
          minHeight: iconSize + 8,
        ),
      ),
    );

    final quantityBadge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .1),
        borderRadius: AppRadius.allXs,
      ),
      child: Text(
        item.quantity.toString(),
        style: theme.textTheme.titleMedium?.copyWith(
          fontSize: quantityFontSize,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );

    final increaseButton = Semantics(
      label: '${l10n.increaseQuantity}: $productName',
      button: true,
      child: IconButton(
        icon: Icon(
          Icons.add_circle_outline,
          color: canIncrease ? AppColors.primary : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          size: iconSize,
        ),
        onPressed: canIncrease ? () => cartNotifier.increaseQuantity(item) : null,
        tooltip: l10n.increaseQuantity,
        splashRadius: 20.0,
        padding: const EdgeInsets.all(4.0),
        constraints: BoxConstraints(
          minWidth: iconSize + 8,
          minHeight: iconSize + 8,
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .4),
        borderRadius: borderRadius ??
            (axis == Axis.horizontal
                ? AppRadius.allMd
                : AppRadius.allSm),
        border: Border.all(color: AppColors.primary.withValues(alpha: .2)),
      ),
      child: axis == Axis.vertical
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                increaseButton,
                quantityBadge,
                decreaseButton,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                decreaseButton,
                quantityBadge,
                increaseButton,
              ],
            ),
    );
  }
}
