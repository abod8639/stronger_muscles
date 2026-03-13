import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/order/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/order_card.dart';
import 'package:stronger_muscles/routes/routes.dart';

class OrderView extends ConsumerWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(ordersControllerProvider);
    final ordersNotifier = ref.watch(ordersControllerProvider.notifier);

    // جلب باقي الطلبات عند الدخول لصفحة كل الطلبات
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ordersNotifier.fetchAllOrders();
    });

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Orders')),
      body: ordersState.when(
        data: (orders) => orders.isEmpty
            ? const Center(child: Text('No orders found'))
            : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      top: index == 0 ? 30 : 5,
                      bottom: 5,
                    ),
                    child: OrderCard(
                      onTap: () =>
                          context.push(AppRoutes.orderDetails, extra: order),
                      order: order,
                      isDark: isDark,
                      isAr: false,
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
