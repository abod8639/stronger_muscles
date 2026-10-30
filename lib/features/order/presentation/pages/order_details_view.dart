import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/core/constants/app_dimens.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/presentation/utils/order_status_ui.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/order_status_tracker.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderEntity order;
  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final orderDate = order.orderDate;
    final formattedDate = orderDate != null
        ? DateFormat('d MMMM yyyy • hh:mm a').format(orderDate)
        : (order.formattedDate.isNotEmpty ? order.formattedDate : '—');
    final address = order.shippingAddress;
    final phone = order.phoneNumber;
    final trackingNumber = order.trackingNumber;
    final items = order.items ?? const [];
    const gap = SizedBox(height: AppDimens.spacingMd);

    return Scaffold(
      appBar: baseAppBar(context, l10n.orderDetails),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OrderStatusTracker(order: order),
            gap,
            AppSectionCard(
              title: l10n.orderInfo,
              icon: Icons.receipt_long_outlined,
              child: Column(
                children: [
                  AppInfoRow(label: l10n.orderId, value: '#${order.id}'),
                  AppInfoRow(label: l10n.orderDate, value: formattedDate),
                  AppInfoRow(label: l10n.paymentMethod, value: order.paymentMethodLabel(l10n)),
                  AppInfoRow(
                    label: l10n.paymentStatus,
                    value: '',
                    valueWidget: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: AppBadge(
                        label: order.isPaid ? l10n.paid : l10n.pending,
                        color: order.isPaid ? AppColors.success : AppColors.warning,
                      ),
                    ),
                  ),
                  if (trackingNumber != null && trackingNumber.isNotEmpty)
                    AppInfoRow(label: l10n.trackingNumber, value: trackingNumber),
                ],
              ),
            ),
            gap,
            if (address != null) ...[
              AppSectionCard(
                title: l10n.deliveryAddress,
                icon: Icons.location_on_outlined,
                child: Column(
                  children: [
                    AppInfoRow(label: l10n.street, value: address.street),
                    AppInfoRow(label: l10n.city, value: address.city),
                    if (phone != null && phone.isNotEmpty)
                      AppInfoRow(label: l10n.phone, value: phone),
                  ],
                ),
              ),
              gap,
            ],
            AppSectionCard(
              title: l10n.orderItems,
              icon: Icons.shopping_bag_outlined,
              child: Column(
                children: [
                  for (final (index, item) in items.indexed) ...[
                    if (index > 0)
                      Divider(height: 1.0, color: context.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                    AppOrderItemTile(
                      imageUrl: item.imageUrl,
                      title: item.productName,
                      subtitle: [item.selectedFlavor, item.selectedSize]
                          .whereType<String>()
                          .where((v) => v.isNotEmpty)
                          .join(' • '),
                      quantity: item.quantity,
                      unitPrice: item.unitPrice,
                      total: item.subtotal,
                    ),
                  ],
                ],
              ),
            ),
            gap,
            AppSectionCard(
              title: l10n.paymentSummary,
              icon: Icons.payments_outlined,
              child: Column(
                children: [
                  AppPriceRow(label: l10n.subtotal, amount: order.subtotal),
                  AppPriceRow(label: l10n.shippingCost, amount: order.shippingCost),
                  if (order.taxAmount > 0) AppPriceRow(label: l10n.tax, amount: order.taxAmount),
                  if (order.discount > 0)
                    AppPriceRow(label: l10n.discount, amount: order.discount, isDiscount: true),
                  const Divider(height: AppDimens.spacingLg + 4),
                  AppPriceRow(label: l10n.totalAmount, amount: order.totalAmount, isTotal: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
