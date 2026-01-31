import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles/presentation/pages/oreder/widgets/order_card.dart';

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
    final controller = Get.find<OrdersController>();
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
              return OrderCard(
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
            onPressed: () => Get.toNamed('/order_view'), // مثال للتنقل
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            child: Text(isAr ? 'عرض الكل' : 'View All'),
          ),
        ],
      ),
    );
  }
}
