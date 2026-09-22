import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/cart/data/models/cart_item_model.dart';
import 'package:stronger_muscles/features/checkout/presentation/widgets/build_checkout_section.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/cart_item_card.dart';

const double _listTopSpacing = 10.0;

class BuildCartContent extends StatelessWidget {
  final List<CartItemModel> items;

  const BuildCartContent({super.key, required this.items});

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
        const BuildCheckoutSection(),
      ],
    );
  }
}
