import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles/presentation/pages/oreder/order_details_view.dart';
import 'package:stronger_muscles/presentation/pages/oreder/widgets/order_card.dart';

const int _maxOrdersToDisplay = 3;
const double _horizontalPadding = 16.0;
const double _listItemSpacing = 12.0;

class RecentOrdersList extends StatelessWidget {
  const RecentOrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<OrdersController>();
    final isDark = theme.brightness == Brightness.dark;
    final isAr = Get.locale?.languageCode == 'ar';

    return Obx(() {
      final recentOrders = controller.orders.take(_maxOrdersToDisplay).toList();

      if (recentOrders.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, theme, isAr),
          const SizedBox(height: 4),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: _horizontalPadding,
              vertical: 8,
            ),
            itemCount: recentOrders.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: _listItemSpacing),
            itemBuilder: (context, index) {
              final order = recentOrders[index];
              return OrderCard(
                onTap: () => Get.to(() => OrderDetailsView(order: order)),
                order: order,
                isDark: isDark,
                isAr: isAr,
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      );
    });
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, bool isAr) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(1, 0),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Text(
                isAr ? 'الطلبات الأخيرة' : 'Recent Orders',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          // زر عرض الكل بتصميم أبسط
          TextButton(
            onPressed: () => Get.toNamed('/order_view'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              visualDensity: VisualDensity.compact,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isAr ? 'عرض الكل' : 'View All'),
                const SizedBox(width: 4),
                Icon(
                  isAr ? Icons.arrow_back_ios_new : Icons.arrow_forward_ios,
                  size: 10,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
