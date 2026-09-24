import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/features/order/data/models/order_model.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/build_order_item.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/build_price_row.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/build_row_info.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/build_section.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/build_status_tracker.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final theme = Theme.of(context);

    final formattedDate = order.orderDate != null
        ? DateFormat('d MMMM yyyy • hh:mm a').format(order.orderDate!)
        : (order.formattedDate.isNotEmpty ? order.formattedDate : '—');

    return Scaffold(
      appBar: AppBar(
        title: Text(isAr ? 'تفاصيل الطلب' : 'Order Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // تتبع حالة الطلب التفاعلي
            buildStatusTracker(isDark, isAr, order),
            const SizedBox(height: 16),

            // تفاصيل الطلب العامة
            buildSection(
              isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? 'معلومات الطلب' : 'Order Info',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildRowInfo(isAr ? 'رقم الطلب' : 'Order ID', '#${order.id}'),
                  const SizedBox(height: 8),
                  buildRowInfo(isAr ? 'تاريخ الطلب' : 'Order Date', formattedDate),
                  const SizedBox(height: 8),
                  buildRowInfo(
                    isAr ? 'طريقة الدفع' : 'Payment Method',
                    order.paymentMethod.toUpperCase(),
                  ),
                  const SizedBox(height: 8),
                  buildRowInfo(
                    isAr ? 'حالة الدفع' : 'Payment Status',
                    order.paymentStatus == 'paid'
                        ? (isAr ? 'تم الدفع' : 'Paid')
                        : (isAr ? 'قيد الانتظار' : 'Pending'),
                  ),
                  if (order.trackingNumber != null &&
                      order.trackingNumber!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    buildRowInfo(
                      isAr ? 'رقم التتبع' : 'Tracking Number',
                      order.trackingNumber!,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // عنوان التوصيل إن وجد
            if (order.shippingAddress != null) ...[
              buildSection(
                isDark,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr ? 'عنوان التوصيل' : 'Delivery Address',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildRowInfo(
                      isAr ? 'الشارع' : 'Street',
                      order.shippingAddress!.street,
                    ),
                    const SizedBox(height: 8),
                    buildRowInfo(
                      isAr ? 'المدينة' : 'City',
                      order.shippingAddress!.city,
                    ),
                    if (order.phoneNumber != null &&
                        order.phoneNumber!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      buildRowInfo(
                        isAr ? 'رقم الهاتف' : 'Phone',
                        order.phoneNumber!,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // عناصر الطلب
            Text(
              isAr ? 'المنتجات المطلوبة' : 'Order Items',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...(order.items ?? []).map(
              (item) => buildOrderItem(item, isDark, isAr),
            ),
            const SizedBox(height: 16),

            // ملخص الحساب
            buildSection(
              isDark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isAr ? 'ملخص الحساب' : 'Payment Summary',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildPriceRow(isAr ? 'المجموع الفرعي' : 'Subtotal', order.subtotal, isAr),
                  buildPriceRow(isAr ? 'تكلفة الشحن' : 'Shipping Cost', order.shippingCost, isAr),
                  if (order.discount > 0)
                    buildPriceRow(
                      isAr ? 'الخصم' : 'Discount',
                      order.discount,
                      isAr,
                      isDiscount: true,
                    ),
                  const Divider(height: 20),
                  buildPriceRow(
                    isAr ? 'الإجمالي الكلي' : 'Total Amount',
                    order.totalAmount,
                    isAr,
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
