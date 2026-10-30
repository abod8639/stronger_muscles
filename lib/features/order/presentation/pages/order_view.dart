import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/order/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/order_card.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

class OrderView extends ConsumerWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(ordersControllerProvider);
    final notifier = ref.read(ordersControllerProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: baseAppBar(context, l10n.orders),
      body: ordersState.when(
        data: (orders) {
          if (orders.isEmpty) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: notifier.refreshOrders,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppEmptyState(
                      icon: Icons.receipt_long_outlined,
                      title: l10n.noOrdersFound,
                      actionText: l10n.startShopping,
                      actionIcon: Icons.storefront_outlined,
                      onActionTap: () => context.go(AppRoutes.main),
                    ),
                  ),
                ],
              ),
            );
          }

          final isLoadingMore = ref.watch(
            ordersControllerProvider.notifier.select((n) => n.isLoadingMore),
          );
          final hasMore = ref.watch(
            ordersControllerProvider.notifier.select((n) => n.hasMore),
          );

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: notifier.refreshOrders,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppDimens.spacingLg),
              itemCount: orders.length + (isLoadingMore ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(height: AppDimens.spacingMd),
              itemBuilder: (context, index) {
                if (index >= orders.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppDimens.spacingLg),
                    child: Center(
                      child: SizedBox.square(
                        dimension: 24.0,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    ),
                  );
                }

                // Trigger pagination when reaching near the end
                if (index == orders.length - 2 && hasMore && !isLoadingMore) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    notifier.loadMoreOrders();
                  });
                }

                final order = orders[index];
                return OrderCard(
                  order: order,
                  onTap: () => context.push(AppRoutes.orderDetails, extra: order),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppEmptyState(
          icon: AppErrorCard.iconFor(error),
          iconColor: AppColors.error,
          title: AppErrorCard.messageFor(error, l10n),
          actionText: l10n.retry,
          actionIcon: Icons.refresh_rounded,
          onActionTap: notifier.refreshOrders,
        ),
      ),
    );
  }
}
