import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/core/utils/functions/handle_delete_from_wishlist.dart';

import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

const double _iconSize = 28.0;

class DeleteButtonFromWishlist extends ConsumerWidget {
  final ProductModel product;
  const DeleteButtonFromWishlist({super.key, required this.product});

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
          size: _iconSize,
          color: AppColors.primary,
        ),
        onPressed: () => handleDeleteFromWishlist(context, ref, product),
        tooltip: l10n.removeFromWishlist,
        splashRadius: 24.0,
      ),
    );
  }
}
