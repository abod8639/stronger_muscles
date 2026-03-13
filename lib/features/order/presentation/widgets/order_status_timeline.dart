import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/order/data/models/order_model.dart';

class OrderStatusTimeline extends StatelessWidget {
  final OrderModel order;
  const OrderStatusTimeline({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // This is a simplified version. A real implementation would be more complex.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status: ${order.status}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        // A real timeline widget would go here
      ],
    );
  }
}
