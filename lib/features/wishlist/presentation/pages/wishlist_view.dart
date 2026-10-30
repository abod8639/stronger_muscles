import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/wishlist/presentation/controllers/wishlist_controller.dart';
import 'package:stronger_muscles/features/wishlist/presentation/utils/handle_delete_from_wishlist.dart';
import 'package:stronger_muscles/features/wishlist/presentation/widgets/wishlist_item_card.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';
import 'package:stronger_muscles/routes/routes.dart';

/// Presentation page displaying customer's wishlist items with pull-to-refresh
/// and swipe-to-remove.
class WishlistView extends ConsumerWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistItems = ref.watch(wishlistControllerProvider);
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(wishlistControllerProvider.notifier);

    return Scaffold(
      appBar: baseAppBar(context, l10n.wishlist),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: notifier.refresh,
        child: wishlistItems.isEmpty
            ? CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppEmptyState(
                      icon: Icons.favorite_border_rounded,
                      title: l10n.yourWishlistIsEmpty,
                      subtitle: l10n.startAddingFavorites,
                      actionText: l10n.startShopping,
                      actionIcon: Icons.storefront_outlined,
                      onActionTap: () => context.go(AppRoutes.main),
                    ),
                  ),
                ],
              )
            : ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.all(AppDimens.spacingLg),
                itemCount: wishlistItems.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppDimens.spacingMd),
                itemBuilder: (context, index) {
                  final product = wishlistItems[index];
                  return AppSwipeToDelete(
                    dismissKey: ValueKey('wishlist_${product.id}'),
                    onDeleted: () => handleDeleteFromWishlist(context, ref, product),
                    child: WishlistItemCard(product: product),
                  );
                },
              ),
      ),
    );
  }
}
