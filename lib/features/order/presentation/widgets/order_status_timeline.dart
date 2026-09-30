import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/build_status_tracker.dart';

class OrderStatusTimeline extends StatelessWidget {
  final OrderEntity order;
  const OrderStatusTimeline({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return buildStatusTracker(isDark, isAr, order);
  }
}
