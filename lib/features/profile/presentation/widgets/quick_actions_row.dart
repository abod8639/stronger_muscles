import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/utils/components/app_card.dart';
import 'package:stronger_muscles/features/order/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles/features/wishlist/presentation/controllers/wishlist_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/routes/routes.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class QuickActionsRow extends ConsumerWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final ordersCount = ref.watch(ordersControllerProvider).value?.length ?? 0;
    final wishlistCount = ref.watch(wishlistControllerProvider).length;
    final addressesCount = ref.watch(addressControllerProvider).value?.length ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
      child: Row(
        children: [
          Expanded(
            child: _buildQuickActionCard(
              context,
              icon: Icons.shopping_bag_outlined,
              label: l10n.orders,
              value: ordersCount.toString(),
              color: AppColors.primary,
              onTap: () {},
            ),
          ),
          const SizedBox(width: AppDimens.spacingMd),
          Expanded(
            child: _buildQuickActionCard(
              context,
              icon: Icons.favorite_outline,
              label: l10n.wishlist,
              value: wishlistCount.toString(),
              color: AppColors.error,
              onTap: () => context.go(AppRoutes.wishlist),
            ),
          ),
          const SizedBox(width: AppDimens.spacingMd),
          Expanded(
            child: _buildQuickActionCard(
              context,
              icon: Icons.location_on_outlined,
              label: l10n.addresses,
              value: addressesCount.toString(),
              color: AppColors.success,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppDimens.spacingLg),
      borderRadius: AppDimens.borderRadiusMd,
      boxShadow: AppDimens.subtleShadow(theme.shadowColor),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppDimens.iconMd),
          const SizedBox(height: AppDimens.spacingSm),
          Text(
            value,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppDimens.spacingXs),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.0,
              color: AppColors.greyDark,
            ),
          ),
        ],
      ),
    );
  }
}
