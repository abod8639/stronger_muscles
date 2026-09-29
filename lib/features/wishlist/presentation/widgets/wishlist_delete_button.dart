import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/wishlist/presentation/utils/handle_delete_from_wishlist.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Delete button that removes a product from the wishlist with undo support.
class WishlistDeleteButton extends ConsumerWidget {
  const WishlistDeleteButton({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      label:
          '${l10n.removeFromWishlist}: ${product.getLocalizedName(locale: l10n.localeName)}',
      button: true,
      child: IconButton(
        icon: const Icon(
          Icons.delete_outline_rounded,
          size: AppDimens.iconMd,
          color: AppColors.primary,
        ),
        onPressed: () => handleDeleteFromWishlist(context, ref, product),
        tooltip: l10n.removeFromWishlist,
        splashRadius: 24.0,
      ),
    );
  }
}
