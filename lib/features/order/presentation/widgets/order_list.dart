import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import 'order_card.dart';

class OrderList extends GetView<OrderController> {
  const OrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        itemCount: controller.items.length,
        itemBuilder: (_, i) => OrderCard(entity: controller.items[i]),
      );
    });
  }
}
