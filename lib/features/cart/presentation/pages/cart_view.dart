import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/cart/presentation/controllers/cart_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/main_controller.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/build_cart_content.dart';
import 'package:stronger_muscles/features/cart/presentation/widgets/empty_cart_view.dart';

class CartView extends ConsumerWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('السلة'), centerTitle: true),
      body: cartState.when(
        data: (items) => items.isEmpty
            ? EmptyCartView(
                onGoShopping: () =>
                    ref.read(mainControllerProvider.notifier).changeTabIndex(0),
              )
            : const BuildCartContent(),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('خطأ: $e')),
      ),
    );
  }
}
