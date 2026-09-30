import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/components/app_card.dart';
import 'package:stronger_muscles/features/order/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class PurchaseStatsCard extends StatelessWidget {
  const PurchaseStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PurchaseStatsCardContent();
  }
}

class _PurchaseStatsCardContent extends ConsumerWidget {
  const _PurchaseStatsCardContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersControllerProvider).value ?? [];
    final totalSpent = orders.fold(0.0, (sum, order) => sum + order.totalAmount);
    final deliveredOrders = orders.where((o) => o.status.toLowerCase() == 'delivered').length;
    final intl10n = AppLocalizations.of(context)!;

    return AppCard(
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
      padding: const EdgeInsets.all(AppDimens.spacingXl),
      gradient: const LinearGradient(
        colors: [AppColors.primary, AppColors.primaryDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: AppDimens.borderRadiusLg,
      boxShadow: AppDimens.coloredShadow(AppColors.primary),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            intl10n.totalSpent,
            'LE ${totalSpent.toStringAsFixed(0)}',
            Icons.payments_outlined,
          ),
          Container(
            height: 50.0,
            width: 1.0,
            color: AppColors.white.withValues(alpha: 0.3),
          ),
          _buildStatItem(
            intl10n.completed,
            '$deliveredOrders',
            Icons.check_circle_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.white, size: AppDimens.iconMd),
        const SizedBox(height: AppDimens.spacingSm),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: AppDimens.spacingXs),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            color: AppColors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}
