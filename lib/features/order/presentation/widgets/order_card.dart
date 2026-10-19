import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/build_product_image.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final bool isDark;
  final bool isAr;
  final VoidCallback? onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.isDark,
    required this.isAr,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final statusData = _getStatusData(order.status, l10n);
    final statusColor = statusData['color'] as Color;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14.0),
      borderRadius: AppRadius.allLg,
      child: Column(
        children: [
          // Upper section: Icon, ID, Date, and Status Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 18.0,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${order.id.length > 6 ? order.id.substring(0, 6) : order.id}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    if (order.orderDate != null)
                      Text(
                        DateFormat('MMM dd, yyyy • hh:mm a')
                            .format(order.orderDate!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
              AppBadge(
                label: statusData['text'] as String,
                color: statusColor,
                alpha: 0.12,
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(height: 1.0, thickness: 0.5),
          ),
          // Lower section: Thumbnail, Product Name, and Price
          Row(
            children: [
              buildProductImage(order.items?.firstOrNull?.imageUrl),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.items?.firstOrNull?.productName ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if ((order.items?.length ?? 0) > 1)
                      Text(
                        '+${order.items!.length - 1} ${l10n.itemsMore}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    order.totalAmount.toStringAsFixed(2),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    l10n.currency,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusData(String status, AppLocalizations l10n) {
    switch (status.toLowerCase()) {
      case 'pending':
        return {
          'text': l10n.pending,
          'color': AppColors.warning,
        };
      case 'processing':
        return {
          'text': l10n.processing,
          'color': AppColors.primary,
        };
      case 'shipped':
        return {
          'text': l10n.shipped,
          'color': Colors.blue,
        };
      case 'delivered':
        return {
          'text': l10n.delivered,
          'color': AppColors.success,
        };
      case 'cancelled':
      case 'canceled':
        return {
          'text': l10n.cancelled,
          'color': AppColors.error,
        };
      default:
        return {
          'text': status.toUpperCase(),
          'color': AppColors.greyDark,
        };
    }
  }
}
