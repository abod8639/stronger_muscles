import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/wishlist/presentation/controllers/wishlist_controller.dart';
import 'package:stronger_muscles/features/wishlist/presentation/widget/wishlist_item_card.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class WishlistView extends ConsumerWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistItems = ref.watch(wishlistControllerProvider);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          localizations.wishlist,
          style: Theme.of(context).textTheme.titleLarge,

          // style: const TextStyle(color: AppColors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: wishlistItems.isEmpty
          ? const _EmptyWishlistState()
          : ListView.builder(
              itemCount: wishlistItems.length,
              physics: const BouncingScrollPhysics(),
              addRepaintBoundaries: true,
              itemBuilder: (context, index) {
                final product = wishlistItems[index];
                return WishlistItemCard(product: product);
              },
            ),
    );
  }
}

class _EmptyWishlistState extends StatelessWidget {
  const _EmptyWishlistState();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 80, color: AppColors.grey),
          const SizedBox(height: 16.0),
          Text(
            localizations.yourWishlistIsEmpty,
            style: const TextStyle(fontSize: 18.0, color: AppColors.grey),
          ),
          Text(
            localizations.startAddingFavorites,
            style: const TextStyle(fontSize: 16.0, color: AppColors.grey),
          ),
        ],
      ),
    );
  }
}
