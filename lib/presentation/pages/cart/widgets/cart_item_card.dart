import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/cart_item_model.dart';
import 'package:stronger_muscles/presentation/pages/cart/widgets/build_product_cart_details.dart';
import 'package:stronger_muscles/presentation/pages/cart/widgets/build_product_cart_image.dart';
import 'package:stronger_muscles/presentation/widgets/build_quantity_controls.dart';
import 'package:stronger_muscles/routes/routes.dart';

class CartItemCard extends StatelessWidget {
  static const double _borderRadius = 12.0;
  static const double _cardElevation = 2.0;
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 8.0;
  static const double _contentPadding = 12.0;
  static const double _spacing = 16.0;

  final CartItemModel item;

  const CartItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
      elevation: _cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: InkWell(
        onTap: () => _navigateToProductDetails(),
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(_contentPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildProductCartImage(item),
              const SizedBox(width: _spacing),
              Expanded(
                child: buildProductCartDetails(item),
              ),
              const SizedBox(width: 8.0),
              buildQuantityControls(item.product),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToProductDetails() {
    Get.toNamed(
      AppRoutes.productDetails,
      arguments: {
        'product': item.product,
        'selectedFlavor': item.selectedFlavor,
        'selectedSize': item.selectedSize,
      },
    );
  }
}
