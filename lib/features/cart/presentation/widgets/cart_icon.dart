import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';

class CartIcon extends ConsumerWidget {
  const CartIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);
    final itemCount = cartState.value?.length ?? 0;

    return Badge(
      backgroundColor: AppColors.primary,
      isLabelVisible: itemCount > 0,
      label: Text(
        itemCount.toString(),
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
      child: const Icon(Icons.shopping_cart),
    );
  }
}
