import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/controllers/profile_controller.dart';

const int _maxOrdersDisplay = 5;
const double _headerIndicatorWidth = 4.0;
const double _headerIndicatorHeight = 20.0;
const double _headerIndicatorBorderRadius = 10.0;
const double _headerSpacing = 8.0;
const double _listItemSpacing = 12.0;

class RecentOrdersList extends StatelessWidget {
  const RecentOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<ProfileController>();
    final isDark = theme.brightness == Brightness.dark;
    final isAr = Get.locale?.languageCode == 'ar';

    return Obx(() {
      if (controller.orders.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme, isDark, isAr),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            addRepaintBoundaries: true,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: controller.orders.take(_maxOrdersDisplay).length,
            separatorBuilder: (context, index) => const SizedBox(height: _listItemSpacing),
            itemBuilder: (context, index) {
              return _OrderCard(
                order: controller.orders[index],
                isDark: isDark,
                isAr: isAr,
              );
            },
          ),
        ],
      );
    });
  }

  Widget _buildHeader(ThemeData theme, bool isDark, bool isAr) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: _headerIndicatorWidth,
                height: _headerIndicatorHeight,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(_headerIndicatorBorderRadius),
                ),
              ),
              const SizedBox(width: _headerSpacing),
              Text(
                isAr ? 'الطلبات الأخيرة' : 'Recent Orders',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () => Get.toNamed('/orders'), // مثال للتنقل
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: Text(isAr ? 'عرض الكل' : 'View All'),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isDark;
  final bool isAr;

  const _OrderCard({
    required this.order,
    required this.isDark,
    required this.isAr,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusData = _getStatusData(order.status, isAr);
    final statusColor = statusData['color'] as Color;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252525) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            /* الانتقال لتفاصيل الطلب */
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                // الجزء العلوي: الرقم والحالة
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr
                                ? 'طلب #${order.id.toString().substring(0, 6)}'
                                : 'Order #${order.id.toString().substring(0, 6)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            DateFormat(
                              'MMM dd, yyyy • hh:mm a',
                            ).format(order.orderDate),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(statusData['text'], statusColor),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, thickness: 0.5),
                ),
                // الجزء السفلي: الصورة والسعر
                Row(
                  children: [
                    _buildProductImage(order.items?.first.imageUrl),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.items?.first.productName ?? '',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if ((order.items?.length ?? 0) > 1)
                            Text(
                              isAr
                                  ? '+${order.items!.length - 1} منتجات أخرى'
                                  : '+${order.items!.length - 1} items more',
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
                          isAr ? 'ج.م' : 'EGP',
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
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProductImage(String? url) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: url != null
            ? Image.network(url, fit: BoxFit.cover)
            : Icon(Icons.inventory_2_outlined, color: Colors.grey[400]),
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
        return {'text': isAr ? 'تم الشحن' : 'Shipped', 'color': Colors.blue};
      case 'delivered':
        return {
          'text': isAr ? 'تم التوصيل' : 'Delivered',
          'color': AppColors.success,
        };
      case 'cancelled':
        return {'text': isAr ? 'ملغي' : 'Cancelled', 'color': AppColors.error};
      default:
        return {'text': status.toUpperCase(), 'color': AppColors.greyDark};
    }
  }
}
