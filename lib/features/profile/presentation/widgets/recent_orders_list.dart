import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/components/section_title.dart';
import 'package:stronger_muscles/features/order/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/order_card.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/language_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

const int _maxOrdersToDisplay = 3;

class RecentOrdersList extends ConsumerWidget {
  const RecentOrdersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final ordersState = ref.watch(ordersControllerProvider);
    final isDark = theme.brightness == Brightness.dark;
    final locale = ref.watch(languageControllerProvider);
    final isAr = locale.languageCode == 'ar';

    return ordersState.when(
      data: (orders) {
        final recentOrders = orders.take(_maxOrdersToDisplay).toList();
        if (recentOrders.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(
              title: l10n.recentOrders,
              leading: Container(
                width: 3,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: AppDimens.borderRadiusXs,
                  boxShadow: AppDimens.coloredShadow(AppColors.primary, alpha: 0.3),
                ),
              ),
              actionText: l10n.viewAll,
              onActionTap: () => context.push(AppRoutes.orderView),
            ),
            const SizedBox(height: 4),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spacingLg,
                vertical: AppDimens.spacingSm,
              ),
              itemCount: recentOrders.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppDimens.spacingMd),
              itemBuilder: (context, index) {
                final order = recentOrders[index];
                return OrderCard(
                  onTap: () =>
                      context.push(AppRoutes.orderDetails, extra: order),
                  order: order,
                  isDark: isDark,
                  isAr: isAr,
                );
              },
            ),
            const SizedBox(height: AppDimens.spacingSm),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('${l10n.error}: $e')),
    );
  }
}
