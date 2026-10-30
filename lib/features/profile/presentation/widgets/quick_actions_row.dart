import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/order/order_feature.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/features/wishlist/wishlist_feature.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Orders / wishlist / addresses counters with shortcuts.
class QuickActionsRow extends ConsumerWidget {
  /// Called when the addresses counter is tapped (e.g. scroll to the section).
  final VoidCallback? onAddressesTap;

  const QuickActionsRow({super.key, this.onAddressesTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final ordersCount =
        ref.watch(ordersControllerProvider.select((state) => state.valueOrNull?.length ?? 0));
    final wishlistCount = ref.watch(wishlistControllerProvider.select((items) => items.length));
    final addressesCount =
        ref.watch(addressControllerProvider.select((state) => state.valueOrNull?.length ?? 0));

    final stats = [
      AppStatCard(
        icon: Icons.shopping_bag_outlined,
        label: l10n.orders,
        value: '$ordersCount',
        color: AppColors.primary,
        onTap: () => context.push(AppRoutes.orderView),
      ),
      AppStatCard(
        icon: Icons.favorite_outline_rounded,
        label: l10n.wishlist,
        value: '$wishlistCount',
        color: AppColors.error,
        onTap: () => context.go(AppRoutes.wishlist),
      ),
      AppStatCard(
        icon: Icons.location_on_outlined,
        label: l10n.addresses,
        value: '$addressesCount',
        color: AppColors.success,
        onTap: onAddressesTap,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingLg),
      child: Row(
        children: [
          for (final (index, stat) in stats.indexed) ...[
            if (index > 0) const SizedBox(width: AppDimens.spacingMd),
            Expanded(child: stat),
          ],
        ],
      ),
    );
  }
}
