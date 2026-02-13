import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/presentation/pages/oreder/widgets/build_info_item.dart';
import 'package:stronger_muscles/presentation/pages/oreder/widgets/build_order_item.dart';
import 'package:stronger_muscles/presentation/pages/oreder/widgets/build_price_row.dart';
import 'package:stronger_muscles/presentation/pages/oreder/widgets/build_row_info.dart';
import 'package:stronger_muscles/presentation/pages/oreder/widgets/build_section.dart';
import 'package:stronger_muscles/presentation/pages/oreder/widgets/build_status_tracker.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isAr = Get.locale?.languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final theme = Theme.of(context);
    final statusData = _getStatusData(order.status, isAr);
    final statusColor = statusData['color'] as Color;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(color: AppColors.primary, Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(isAr ? 'تفاصيل الطلب' : 'Order Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Order Status Card
            buildSection(
              isDark,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? 'رقم الطلب' : 'Order ID',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '#${order.id.substring(0, 8)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          statusData['text'],
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildInfoItem(
                        icon: Icons.calendar_today_outlined,
                        label: isAr ? 'تاريخ الطلب' : 'Date',
                        value: DateFormat(
                          'dd MMM yyyy',
                        ).format(order.orderDate),
                      ),
                      buildInfoItem(
                        icon: Icons.access_time,
                        label: isAr ? 'الوقت' : 'Time',
                        value: DateFormat('hh:mm a').format(order.orderDate),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            buildStatusTracker(isDark, isAr, order),

            // const SizedBox(height: 16),
            const SizedBox(height: 16),
            // Order Items
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (order.items != null && order.items!.isNotEmpty)
                  ...order.items!.map(
                    (item) => buildOrderItem(item, isDark, isAr),
                  ),
              ],
            ),
            const SizedBox(height: 5),

            // Shipping Info
            buildSection(
              isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isAr ? 'معلومات الشحن' : 'Shipping Details',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  if (order.userName != null) ...[
                    buildRowInfo(
                      isAr ? 'المستلم' : 'Receiver',
                      order.userName!,
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (order.phoneNumber != null) ...[
                    buildRowInfo(
                      isAr ? 'رقم الهاتف' : 'Phone',
                      order.phoneNumber!,
                    ),
                    const SizedBox(height: 8),
                  ],

                  if (order.shippingAddress != null)
                    buildRowInfo(
                      isAr ? 'العنوان' : 'Address',
                      order.shippingAddress!.fullAddress,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Payment Summary
            buildSection(
              isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isAr ? 'ملخص الدفع' : 'Payment Summary',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  buildPriceRow(
                    isAr ? 'المجموع الفرعي' : 'Subtotal',
                    order.subtotal,
                    isAr,
                  ),
                  buildPriceRow(
                    isAr ? 'الشحن' : 'Shipping',
                    order.shippingCost,
                    isAr,
                  ),
                  if (order.discount > 0)
                    buildPriceRow(
                      isAr ? 'الخصم' : 'Discount',
                      -order.discount,
                      isAr,
                      isDiscount: true,
                    ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(),
                  ),
                  buildPriceRow(
                    isAr ? 'الإجمالي' : 'Total',
                    order.totalAmount,
                    isAr,
                    isTotal: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
