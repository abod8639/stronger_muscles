import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/checkout/presentation/widgets/build_checkout_section.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/cart_item_card.dart';

const double _listTopSpacing = 10.0;

class BuildCartContent extends ConsumerWidget {
  const BuildCartContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);
    final theme = Theme.of(context);

    return cartState.when(
      data: (items) => Column(
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
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }
}
