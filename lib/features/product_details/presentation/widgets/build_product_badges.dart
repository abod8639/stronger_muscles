import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/utils/components/app_badge.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

Widget buildProductBadges(
  ProductModel product,
  BuildContext context,
  double alpha,
) {
  final l10n = AppLocalizations.of(context);
  if (l10n == null) return const SizedBox.shrink();

  final badges = <Widget>[];

  // Discount Badge
  if (product.hasDiscount) {
    badges.add(
      AppBadge(
        label: '${product.discountPercentage.toInt()}% ${l10n.percentOff}',
        color: Colors.red,
        alpha: alpha,
      ),
    );
  }

  // New Arrival
  if (product.newArrival) {
    badges.add(
      AppBadge(
        label: l10n.newArrival,
        color: Colors.green,
        alpha: alpha,
      ),
    );
  }

  // Best Seller
  if (product.bestSeller) {
    badges.add(
      AppBadge(
        label: l10n.bestSeller,
        color: Colors.orange,
        alpha: alpha,
      ),
    );
  }

  // Featured
  if (product.featured) {
    badges.add(
      AppBadge(
        label: l10n.featured,
        color: AppColors.primary,
        alpha: alpha,
      ),
    );
  }

  // Stock Status
  if (product.stockQuantity <= 0) {
    badges.add(
      AppBadge(
        label: l10n.outOfStock,
        color: Colors.grey,
        alpha: alpha,
      ),
    );
  }

  if (badges.isEmpty) return const SizedBox.shrink();

  return Wrap(spacing: 8, runSpacing: 8, children: badges);
}
