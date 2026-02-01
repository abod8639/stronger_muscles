import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/presentation/pages/oreder/widgets/build_info_item.dart';
import 'package:stronger_muscles/presentation/pages/oreder/widgets/build_price_row.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // Determine language and theme mode
    final isAr = Get.locale?.languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final theme = Theme.of(context);
    final statusData = _getStatusData(order.status, isAr);
    final statusColor = statusData['color'] as Color;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
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
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '#${order.id.substring(0, 8)}',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: statusColor.withValues(alpha: 0.2)),
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
                        value: DateFormat('dd MMM yyyy').format(order.orderDate),
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
            buildStatusTracker(isDark, isAr,  order ),
            // const SizedBox(height: 16),

            // Order Items
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text(
                    isAr ? 'المنتجات' : 'Items',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                if (order.items != null && order.items!.isNotEmpty)
                  ...order.items!.map((item) => buildOrderItem(item, isDark, isAr, theme)),
              ],
            ),
            const SizedBox(height: 16),

            // Shipping Info
            buildSection(
              isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_shipping_outlined, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        isAr ? 'معلومات الشحن' : 'Shipping Details',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  if (order.userName != null) ...[
                    buildRowInfo(isAr ? 'المستلم' : 'Receiver', order.userName!, theme),
                    const SizedBox(height: 8),
                  ],
                  if (order.phoneNumber != null) ...[
                    buildRowInfo(isAr ? 'رقم الهاتف' : 'Phone', order.phoneNumber!, theme),
                    const SizedBox(height: 8),
                  ],

                  Builder(
                    builder: (context) {
                      String addressText = order.shippingAddress ?? '';

                      if (order.shippingAddressSnapshot != null) {
                        try {
                          final dynamic decoded =
                              jsonDecode(order.shippingAddressSnapshot!);
                          if (decoded is Map<String, dynamic>) {
                            final address = AddressModel.fromJson(decoded);
                            addressText = address.fullAddress;
                          }
                        } catch (e) {
                          // Fallback to existing string
                        }
                      }
                      
                      if (addressText.isNotEmpty) {
                        return buildRowInfo(
                          isAr ? 'العنوان' : 'Address',
                          addressText,
                          theme,
                        );
                      }
                      return const SizedBox.shrink();
                    },
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
                      Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        isAr ? 'ملخص الدفع' : 'Payment Summary',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  buildPriceRow(isAr ? 'المجموع الفرعي' : 'Subtotal', order.subtotal,  isAr),
                  buildPriceRow(isAr ? 'الشحن' : 'Shipping', order.shippingCost,  isAr),
                  if (order.discount > 0)
                    buildPriceRow(isAr ? 'الخصم' : 'Discount', -order.discount,  isAr, isDiscount: true),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider()),
                  buildPriceRow(isAr ? 'الإجمالي' : 'Total', order.totalAmount,  isAr, isTotal: true),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}


  Widget buildSection(bool isDark, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252525) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }


  Widget buildOrderItem(OrderItemModel item, bool isDark, bool isAr, ThemeData theme) {
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
                  ? Image.network(item.imageUrl!, fit: BoxFit.cover)
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

  Widget buildRowInfo(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
      ],
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

  Widget buildStatusTracker(bool isDark, bool isAr,  OrderModel order) {
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
        }
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
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
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
                                      : (i <= activeIndex ? AppColors.primary : Colors.grey[300]),
                                ),
                              ),
                              // Dot
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i <= activeIndex ? AppColors.primary : Colors.grey[100],
                                  border: Border.all(
                                    color: i <= activeIndex ? AppColors.primary : Colors.grey[300]!,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: i < activeIndex
                                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                                      : Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: i == activeIndex ? Colors.white : Colors.grey[400],
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
                                      : (i < activeIndex ? AppColors.primary : Colors.grey[300]),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            steps[i]['label']!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: i <= activeIndex ? AppColors.primary : Colors.grey,
                              fontWeight: i == activeIndex ? FontWeight.bold : FontWeight.normal,
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ],
          );
        }
      ),
    );
  }

