
// order details view
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/presentation/controllers/orders_controller.dart';

class OrderDetailsView extends StatelessWidget {
  final OrderModel? order;
  const OrderDetailsView({
    super.key,  this.order});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Order Details'),
      ),
    );
  }
}
