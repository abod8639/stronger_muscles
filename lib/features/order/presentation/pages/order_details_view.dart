import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/features/order/data/models/order_model.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/build_order_item.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/build_price_row.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/build_row_info.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/build_section.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/build_status_tracker.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final formattedDate = order.orderDate != null
        ? DateFormat('d MMMM yyyy • hh:mm a').format(order.orderDate!)
        : (order.formattedDate.isNotEmpty ? order.formattedDate : '—');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.orderDetails),
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
                    l10n.orderInfo,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildRowInfo(l10n.orderId, '#${order.id}'),
                  const SizedBox(height: 8),
                  buildRowInfo(l10n.orderDate, formattedDate),
                  const SizedBox(height: 8),
                  buildRowInfo(
                    l10n.paymentMethod,
                    order.paymentMethod.toUpperCase(),
                  ),
                  const SizedBox(height: 8),
                  buildRowInfo(
                    l10n.paymentStatus,
                    order.paymentStatus == 'paid'
                        ? l10n.paid
                        : l10n.pending,
                  ),
                  if (order.trackingNumber != null &&
                      order.trackingNumber!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    buildRowInfo(
                      l10n.trackingNumber,
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
                      l10n.deliveryAddress,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildRowInfo(
                      l10n.street,
                      order.shippingAddress!.street,
                    ),
                    const SizedBox(height: 8),
                    buildRowInfo(
                      l10n.city,
                      order.shippingAddress!.city,
                    ),
                    if (order.phoneNumber != null &&
                        order.phoneNumber!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      buildRowInfo(
                        l10n.phone,
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
              l10n.orderItems,
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
                    l10n.paymentSummary,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  buildPriceRow(l10n.subtotal, order.subtotal, isAr),
                  buildPriceRow(l10n.shippingCost, order.shippingCost, isAr),
                  if (order.discount > 0)
                    buildPriceRow(
                      l10n.discount,
                      order.discount,
                      isAr,
                      isDiscount: true,
                    ),
                  const Divider(height: 20),
                  buildPriceRow(
                    l10n.totalAmount,
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
