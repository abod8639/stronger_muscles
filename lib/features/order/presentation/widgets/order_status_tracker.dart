import 'package:flutter/material.dart';
import 'package:stronger_muscles/core/components/components.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/presentation/utils/order_status_ui.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

/// "Order tracking" card: pending → processing → shipped → delivered,
/// or a cancelled notice.
class OrderStatusTracker extends StatelessWidget {
  final OrderEntity order;

  const OrderStatusTracker({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppSectionCard(
      title: l10n.orderTracking,
      icon: Icons.local_shipping_outlined,
      trailing: AppBadge(label: order.statusLabel(l10n), color: order.statusColor),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: AppStepProgress(
          steps: [l10n.pending, l10n.processing, l10n.shipped, l10n.delivered],
          activeIndex: order.statusStep,
          isCancelled: order.isCancelled,
          cancelledLabel: l10n.orderCancelled,
        ),
      ),
    );
  }
}
