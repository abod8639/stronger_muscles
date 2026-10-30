import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/presentation/utils/order_status_ui.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// Order summary card for order lists: id, date, status, first item and total.
class OrderCard extends StatelessWidget {
  static const double _thumbnailSize = 52.0;

  final OrderEntity order;
  final VoidCallback? onTap;

  const OrderCard({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = context.textTheme;
    final mutedColor = context.colorScheme.onSurfaceVariant;
    final orderDate = order.orderDate;
    final items = order.items ?? const [];
    final firstItem = items.firstOrNull;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14.0),
      child: Column(
        children: [
          Row(
            children: [
              const AppIconTile(
                icon: Icons.shopping_bag_outlined,
                iconSize: 18.0,
                circular: true,
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.shortId,
                      style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (orderDate != null)
                      Text(
                        DateFormat('MMM dd, yyyy • hh:mm a').format(orderDate),
                        style: textTheme.bodySmall?.copyWith(color: mutedColor),
                      ),
                  ],
                ),
              ),
              AppBadge(
                label: order.statusLabel(l10n),
                color: order.statusColor,
                alpha: 0.12,
              ),
            ],
          ),
          Divider(
            height: AppDimens.spacingXl,
            color: context.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          Row(
            children: [
              AppNetworkImage(
                imageUrl: firstItem?.imageUrl,
                width: _thumbnailSize,
                height: _thumbnailSize,
                errorIcon: Icons.inventory_2_outlined,
              ),
              const SizedBox(width: AppDimens.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstItem?.productName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (items.length > 1)
                      Text(
                        '+${items.length - 1} ${l10n.itemsMore}',
                        style: textTheme.labelSmall?.copyWith(color: AppColors.primary),
                      ),
                  ],
                ),
              ),
              AppPriceText(price: order.totalAmount, fontSize: 16.0),
            ],
          ),
        ],
      ),
    );
  }
}
