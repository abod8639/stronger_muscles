import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';

/// Reusable shopping cart icon with reactive item count badge.
class CartIcon extends ConsumerWidget {
  final Color? color;
  final double? size;

  const CartIcon({
    super.key,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);
    final itemCount = cartState.valueOrNull?.length ?? 0;

    return Badge(
      backgroundColor: AppColors.primary,
      isLabelVisible: itemCount > 0,
      label: Text(
        itemCount.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Icon(
        Icons.shopping_cart,
        color: color,
        size: size,
      ),
    );
  }
}
