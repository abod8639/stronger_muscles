import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/order/order_feature.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/profile_skeleton.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Latest few orders with a "View all" shortcut.
class RecentOrdersList extends ConsumerWidget {
  static const int _maxOrdersToDisplay = 3;

  const RecentOrdersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final ordersState = ref.watch(ordersControllerProvider);

    return ordersState.when(
      data: (orders) {
        final recentOrders = orders.take(_maxOrdersToDisplay).toList();
        if (recentOrders.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSectionTitle(
              title: l10n.recentOrders,
              actionText: l10n.viewAll,
              onActionTap: () => context.push(AppRoutes.orderView),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
              child: Column(
                children: [
                  for (final (index, order) in recentOrders.indexed) ...[
                    if (index > 0) const SizedBox(height: AppDimens.spacingMd),
                    OrderCard(
                      order: order,
                      onTap: () => context.push(AppRoutes.orderDetails, extra: order),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const OrdersListSkeleton(itemCount: 2),
      error: (error, _) => AppAlertCard(
        color: AppColors.error,
        icon: AppErrorCard.iconFor(error),
        message: AppErrorCard.messageFor(error, l10n),
        margin: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
        actionLabel: l10n.retry,
        onAction: ref.read(ordersControllerProvider.notifier).refreshOrders,
      ),
    );
  }
}
