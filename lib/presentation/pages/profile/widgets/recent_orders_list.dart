import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/presentation/bindings/profile_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class RecentOrdersList extends StatelessWidget {
  const RecentOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<ProfileController>();
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final isAr = Get.locale?.languageCode == 'ar';

    return Obx(() {
      if (controller.orders.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isAr ? 'الطلبات الأخيرة' : 'Recent Orders',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to All Orders
                  },
                  child: Text(l10n.viewAll),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.orders.take(5).length,
            itemBuilder: (context, index) {
              final order = controller.orders[index];
              return _buildOrderCard(context, order, isDark, isAr);
            },
          ),
        ],
      );
    });
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order, bool isDark, bool isAr) {
    final theme = Theme.of(context);
    
    // Status mapping and colors
    final statusData = _getStatusData(order.status, isAr);
    final statusColor = statusData['color'] as Color;
    final statusText = statusData['text'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isAr ? 'طلب رقم #${order.id}' : 'Order #${order.id}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('MMM dd, yyyy').format(order.orderDate),
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.greyDark,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: order.items != null && order.items!.isNotEmpty
                    ? Image.network(
                        order.items!.first.imageUrl ?? '',
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 45,
                          height: 45,
                          color: AppColors.greyLight,
                          child: const Icon(Icons.inventory_2_outlined, size: 20, color: AppColors.greyDark),
                        ),
                      )
                    : Container(
                        width: 45,
                        height: 45,
                        color: AppColors.greyLight,
                        child: const Icon(Icons.inventory_2_outlined, size: 20, color: AppColors.greyDark),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.items?.isNotEmpty == true
                          ? order.items!.first.productName
                          : (isAr ? 'منتجات الطلب' : 'Order Items'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.white : AppColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if ((order.items?.length ?? 0) > 1)
                      Text(
                        isAr
                            ? '+${(order.items!.length) - 1} منتجات أخرى'
                            : '+${(order.items!.length) - 1} more items',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.greyDark,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${order.totalAmount.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    isAr ? 'ج.م' : 'LE',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.greyDark,
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

  Map<String, dynamic> _getStatusData(String status, bool isAr) {
    switch (status.toLowerCase()) {
      case 'pending':
        return {
          'text': isAr ? 'قيد الانتظار' : 'Pending',
          'color': AppColors.warning,
        };
      case 'processing':
        return {
          'text': isAr ? 'يتم التجهيز' : 'Processing',
          'color': AppColors.primary,
        };
      case 'shipped':
        return {
          'text': isAr ? 'تم الشحن' : 'Shipped',
          'color': Colors.blue,
        };
      case 'delivered':
        return {
          'text': isAr ? 'تم التوصيل' : 'Delivered',
          'color': AppColors.success,
        };
      case 'cancelled':
        return {
          'text': isAr ? 'ملغي' : 'Cancelled',
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

