
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/functions/cache_manager.dart';

Widget buildOrderItem(OrderItemModel item, bool isDark, bool isAr) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF252525) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: item.imageUrl != null
                      ? CachedNetworkImage(
                        cacheManager: CustomCacheManager.instance,
                        imageUrl: item.imageUrl!,
                        fit: BoxFit.cover,
                      )
                      : Icon(Icons.inventory_2_outlined, color: Colors.grey[400]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.selectedFlavor != null || item.selectedSize != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          [item.selectedFlavor, item.selectedSize].where((e) => e != null).join(' | '),
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                        ),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${item.quantity} x ${item.unitPrice.toStringAsFixed(2)}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                 '${item.subtotal.toStringAsFixed(2)} ${isAr ? "ج.م" : "EGP"}',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }
    );
  }

