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

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(isAr ? 'طلباتي' : 'Orders'),
      ),
      body: ordersState.when(
        data: (orders) => orders.isEmpty
            ? RefreshIndicator(
                onRefresh: () =>
                    ref.read(ordersControllerProvider.notifier).refreshOrders(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Text(
                          isAr ? 'لا توجد طلبات سابقة' : 'No orders found',
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(ordersControllerProvider.notifier).refreshOrders(),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: index == 0 ? 16 : 5,
                        bottom: 5,
                      ),
                      child: OrderCard(
                        onTap: () =>
                            context.push(AppRoutes.orderDetails, extra: order),
                        order: order,
                        isDark: isDark,
                        isAr: isAr,
                      ),
                    );
                  },
                ),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isAr ? 'خطأ في جلب الطلبات: $e' : 'Error: $e'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () =>
                    ref.read(ordersControllerProvider.notifier).refreshOrders(),
                child: Text(isAr ? 'إعادة المحاولة' : 'Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
