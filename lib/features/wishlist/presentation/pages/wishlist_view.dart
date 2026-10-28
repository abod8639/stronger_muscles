import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/app_base_app_bar.dart';
import 'package:stronger_muscles/core/components/app_empty_state.dart';
import 'package:stronger_muscles/features/wishlist/presentation/controllers/wishlist_controller.dart';
import 'package:stronger_muscles/features/wishlist/presentation/widgets/wishlist_item_card.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Presentation page displaying customer's wishlist items with pull-to-refresh.
class WishlistView extends ConsumerWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistItems = ref.watch(wishlistControllerProvider);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: baseAppBar(context, localizations.wishlist),
      body: wishlistItems.isEmpty
          ? AppEmptyState(
              icon: Icons.favorite_border_rounded,
              title: localizations.yourWishlistIsEmpty,
              subtitle: localizations.startAddingFavorites,
            )
          : RefreshIndicator(
              onRefresh: () =>
                  ref.read(wishlistControllerProvider.notifier).refresh(),
              child: ListView.builder(
                itemCount: wishlistItems.length,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                addRepaintBoundaries: true,
                itemBuilder: (context, index) {
                  final product = wishlistItems[index];
                  return WishlistItemCard(product: product);
                },
              ),
            ),
    );
  }
}
