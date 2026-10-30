import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/components/app_snack_bar.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';
import 'package:stronger_muscles/features/wishlist/presentation/controllers/wishlist_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Removes [product] from the wishlist and offers an undo snackbar.
void handleDeleteFromWishlist(BuildContext context, WidgetRef ref, ProductEntity product) {
  final wishlistNotifier = ref.read(wishlistControllerProvider.notifier);
  final l10n = AppLocalizations.of(context);

  wishlistNotifier.removeFromWishlist(product);

  final itemName = product.getLocalizedName(locale: l10n?.localeName ?? 'en');
  AppSnackBar.showInfo(
    context,
    l10n != null ? '$itemName ${l10n.removedFromWishlist}' : '$itemName removed from wishlist',
    actionLabel: l10n?.undo ?? 'UNDO',
    onAction: () => wishlistNotifier.addToWishlist(product),
  );
}
