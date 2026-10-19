import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_item_entity.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

Widget buildOrderItem(OrderItemEntity item, bool isDark, bool isAr) {
  return Builder(
    builder: (context) {
      final theme = Theme.of(context);
      final currency =
          AppLocalizations.of(context)?.currency ?? (isAr ? "ج.م" : "EGP");

      return Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        child: AppCard(
          padding: const EdgeInsets.all(12.0),
          borderRadius: AppRadius.allMd,
          boxShadow: context.subtleShadow,
          child: Row(
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.allSm,
                  color: isDark ? Colors.grey[800] : Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: AppRadius.allSm,
                  child: (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                      ? CachedNetworkImage(
                          cacheManager: CustomCacheManager.instance,
                          imageUrl: item.imageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => Icon(
                            Icons.inventory_2_outlined,
                            color: Colors.grey[400],
                          ),
                        )
                      : Icon(
                          Icons.inventory_2_outlined,
                          color: Colors.grey[400],
                        ),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.selectedFlavor != null ||
                        item.selectedSize != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          [
                            item.selectedFlavor,
                            item.selectedSize,
                          ].where((e) => e != null).join(' | '),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4.0),
                    Text(
                      '${item.quantity} x ${item.unitPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                '${item.subtotal.toStringAsFixed(2)} $currency',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
