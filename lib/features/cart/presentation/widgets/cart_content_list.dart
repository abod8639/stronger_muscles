import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/cart/domain/entities/cart_item_entity.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/cart_item_card.dart';

/// Scrollable list of the items in the cart.
class CartContentList extends StatelessWidget {
  final List<CartItemEntity> items;

  const CartContentList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppDimens.spacingLg),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppDimens.spacingMd),
      itemBuilder: (context, index) {
        final item = items[index];
        return CartItemCard(key: ValueKey(item.id), item: item);
      },
    );
  }
}
