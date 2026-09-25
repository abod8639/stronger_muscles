import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/wishlist/presentation/controllers/wishlist_controller.dart';

import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

void handleDeleteFromWishlist(
  BuildContext context,
  WidgetRef ref,
  ProductModel product,
) {
  final wishlistNotifier = ref.read(wishlistControllerProvider.notifier);
  final l10n = AppLocalizations.of(context);

  wishlistNotifier.removeFromWishlist(product);

  final itemName = l10n != null
      ? product.getLocalizedName(locale: l10n.localeName)
      : product.name;
  final message = l10n != null
      ? '$itemName ${l10n.removedFromWishlist}'
      : '$itemName removed from wishlist';
  final undoLabel = l10n?.undo ?? 'UNDO';

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: undoLabel,
        textColor: AppColors.primary,
        onPressed: () {
          wishlistNotifier.addToWishlist(product);
        },
      ),
    ),
  );
}
