import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
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
      _buildBadge('${product.discountPercentage.toInt()}% OFF', Colors.red, alpha),
    );
  }

  // New Arrival
  if (product.newArrival) {
    badges.add(_buildBadge(l10n.newArrival, Colors.green, alpha));
  }

  // Best Seller
  if (product.bestSeller) {
    badges.add(_buildBadge(l10n.bestSeller, Colors.orange, alpha));
  }

  // Featured
  if (product.featured) {
    badges.add(_buildBadge(l10n.featured, AppColors.primary, alpha));
  }

  // Stock Status
  if (product.stockQuantity <= 0) {
    badges.add(_buildBadge('OUT OF STOCK', Colors.grey, alpha));
  }

  if (badges.isEmpty) return const SizedBox.shrink();

  return Wrap(spacing: 8, runSpacing: 8, children: badges);

}
Widget _buildBadge(String label, Color color , double alpha) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: alpha),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    ),
  );
}
