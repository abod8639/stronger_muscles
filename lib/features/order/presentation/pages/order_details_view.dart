import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/build_order_item.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/build_status_tracker.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderEntity order;
  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isAr = context.isArabic;
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status tracker with unified component
            buildStatusTracker(isDark, isAr, order),
            const SizedBox(height: 16.0),

            // Order General Information
            AppCard(
              padding: const EdgeInsets.all(AppDimens.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.orderInfo,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  AppInfoRow(label: l10n.orderId, value: '#${order.id}'),
                  AppInfoRow(label: l10n.orderDate, value: formattedDate),
                  AppInfoRow(
                    label: l10n.paymentMethod,
                    value: order.paymentMethod.toUpperCase(),
                  ),
                  AppInfoRow(
                    label: l10n.paymentStatus,
                    value: order.paymentStatus == 'paid' ? l10n.paid : l10n.pending,
                  ),
                  if (order.trackingNumber != null &&
                      order.trackingNumber!.isNotEmpty)
                    AppInfoRow(
                      label: l10n.trackingNumber,
                      value: order.trackingNumber!,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Delivery Address if present
            if (order.shippingAddress != null) ...[
              AppCard(
                padding: const EdgeInsets.all(AppDimens.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.deliveryAddress,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    AppInfoRow(
                      label: l10n.street,
                      value: order.shippingAddress!.street,
                    ),
                    AppInfoRow(
                      label: l10n.city,
                      value: order.shippingAddress!.city,
                    ),
                    if (order.phoneNumber != null &&
                        order.phoneNumber!.isNotEmpty)
                      AppInfoRow(
                        label: l10n.phone,
                        value: order.phoneNumber!,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
            ],

            // Order Items
            Text(
              l10n.orderItems,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            ...(order.items ?? []).map(
              (item) => buildOrderItem(item, isDark, isAr),
            ),
            const SizedBox(height: 16.0),

            // Payment Summary
            AppCard(
              padding: const EdgeInsets.all(AppDimens.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.paymentSummary,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  AppPriceRow(
                    label: l10n.subtotal,
                    amount: order.subtotal,
                  ),
                  AppPriceRow(
                    label: l10n.shippingCost,
                    amount: order.shippingCost,
                  ),
                  if (order.taxAmount > 0)
                    AppPriceRow(
                      label: l10n.tax,
                      amount: order.taxAmount,
                    ),
                  if (order.discount > 0)
                    AppPriceRow(
                      label: l10n.discount,
                      amount: order.discount,
                      isDiscount: true,
                    ),
                  const Divider(height: 20.0),
                  AppPriceRow(
                    label: l10n.totalAmount,
                    amount: order.totalAmount,
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
