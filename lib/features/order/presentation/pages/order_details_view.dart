import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/order/data/models/order_model.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/order_status_timeline.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderModel order;
  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order #${order.id}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Date: ${order.formattedDate}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Total: LE ${order.totalAmount}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            OrderStatusTimeline(order: order),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text('Items:', style: Theme.of(context).textTheme.titleMedium),
            ...(order.items ?? []).map((item) => ListTile(
                  title: Text(item.productName),
                  subtitle: Text('Quantity: ${item.quantity}'),
                  trailing: Text('LE ${item.price}'),
                )),
          ],
        ),
      ),
    );
  }
}
