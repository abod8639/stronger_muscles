import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles/presentation/pages/oreder/order_details_view.dart';
import 'package:stronger_muscles/presentation/pages/oreder/widgets/order_card.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();
    return Scaffold(
      appBar: AppBar(),
      body: Obx(() {
        if (controller.orders.isEmpty) {
          return const Center(child: Text('No orders found'));
        }
        return ListView.builder(
          itemCount: controller.orders.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 20.0,
              ),
              child: OrderCard(
                onTap: () =>
                    Get.to(OrderDetailsView(order: controller.orders[index])),
                order: controller.orders[index],
                isDark: true,
                isAr: false,
              ),
            );
          },
        );
      }),
    );
  }
}
