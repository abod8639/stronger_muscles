import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/wishlist/presentation/utils/handle_delete_from_wishlist.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Filled-heart toggle that removes a product from the wishlist (with undo).
class WishlistDeleteButton extends ConsumerWidget {
  const WishlistDeleteButton({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final productName = product.getLocalizedName(locale: l10n.localeName);
    return Semantics(
      label: '${l10n.removeFromWishlist}: $productName',
      button: true,
      child: IconButton(
        icon: const Icon(Icons.favorite_rounded, size: 26.0, color: AppColors.primary),
        onPressed: () => handleDeleteFromWishlist(context, ref, product),
        tooltip: l10n.removeFromWishlist,
        splashRadius: 24.0,
      ),
    );
  }
}
