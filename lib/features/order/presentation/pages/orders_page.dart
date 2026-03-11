import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import '../widgets/order_list.dart';

class OrdersPage extends GetView<OrderController> {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: const OrderList(),
    );
  }
}
