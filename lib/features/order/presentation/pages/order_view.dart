import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/order/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/order_card.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

class OrderView extends ConsumerWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(ordersControllerProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isAr = context.isArabic;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(l10n.orders),
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
                        child: AppEmptyState(
                          icon: Icons.receipt_long_outlined,
                          title: l10n.noOrdersFound,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${l10n.error}: $e',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                AppPrimaryButton(
                  text: l10n.retry,
                  onPressed: () =>
                      ref.read(ordersControllerProvider.notifier).refreshOrders(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
