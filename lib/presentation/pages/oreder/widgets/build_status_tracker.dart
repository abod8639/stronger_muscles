import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/presentation/pages/oreder/widgets/build_section.dart';

Widget buildStatusTracker(bool isDark, bool isAr, OrderModel order) {
  if (order.status.toLowerCase() == 'cancelled') {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return buildSection(
          isDark,
          child: Row(
            children: [
              const Icon(Icons.cancel, color: AppColors.error),
              const SizedBox(width: 12),
              Text(
                isAr ? 'تم إلغاء الطلب' : 'Order Cancelled',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  final steps = [
    {'label': isAr ? 'طلب' : 'Order', 'status': 'pending'},
    {'label': isAr ? 'تجهيزات' : 'Process', 'status': 'processing'},
    {'label': isAr ? 'شحن' : 'Shipped', 'status': 'shipped'},
    {'label': isAr ? 'توصيل' : 'Delivery', 'status': 'delivered'},
  ];

  final currentStatus = order.status.toLowerCase();
  int activeIndex = steps.indexWhere((s) => s['status'] == currentStatus);

  // Mapping complex statuses if any
  if (activeIndex == -1) {
    if (currentStatus == 'pending') {
      activeIndex = 0;
    } else if (currentStatus == 'processing') {
      activeIndex = 1;
    } else if (currentStatus == 'shipped') {
      activeIndex = 2;
    } else if (currentStatus == 'delivered') {
      activeIndex = 3;
    } else {
      activeIndex = 0;
    }
  }

  return buildSection(
    isDark,
    child: Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isAr ? 'تتبع حالة الطلب' : 'Order Tracking',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                for (int i = 0; i < steps.length; i++) ...[
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Line before
                            Expanded(
                              child: Container(
                                height: 2,
                                color: i == 0
                                    ? Colors.transparent
                                    : (i <= activeIndex
                                          ? AppColors.primary
                                          : Colors.grey[300]),
                              ),
                            ),
                            // Dot
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: i <= activeIndex
                                    ? AppColors.primary
                                    : Colors.grey[100],
                                border: Border.all(
                                  color: i <= activeIndex
                                      ? AppColors.primary
                                      : Colors.grey[300]!,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: i < activeIndex
                                    ? const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    : Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: i == activeIndex
                                              ? Colors.white
                                              : Colors.grey[400],
                                        ),
                                      ),
                              ),
                            ),
                            // Line after
                            Expanded(
                              child: Container(
                                height: 2,
                                color: i == steps.length - 1
                                    ? Colors.transparent
                                    : (i < activeIndex
                                          ? AppColors.primary
                                          : Colors.grey[300]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          steps[i]['label']!,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: i <= activeIndex
                                ? AppColors.primary
                                : Colors.grey,
                            fontWeight: i == activeIndex
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    ),
  );
}
