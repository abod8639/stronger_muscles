import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/cart_checkout_bottom_bar.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/cart_item_card.dart';

const double _listTopSpacing = 10.0;

/// Displays the scrollable list of items in the cart and sticky checkout bottom bar.
class CartContentList extends StatelessWidget {
  final List<CartItemEntity> items;

  const CartContentList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: _listTopSpacing),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            physics: const BouncingScrollPhysics(),
            addRepaintBoundaries: true,
            itemBuilder: (context, index) {
              final item = items[index];
              return CartItemCard(item: item);
            },
          ),
        ),
        Divider(height: 1, color: theme.colorScheme.outlineVariant),
        const CartCheckoutBottomBar(),
      ],
    );
  }
}

/// Backward compatibility alias
typedef BuildCartContent = CartContentList;
