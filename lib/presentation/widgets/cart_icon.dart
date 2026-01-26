import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/controllers/cart_controller.dart';

final controller = Get.put(CartController());
Widget cartIcon() {
  return Obx(() {
    final itemCount = controller.cartItems.length;
    return Badge(
      backgroundColor: AppColors.primary,
      isLabelVisible: itemCount > 0,
      label: Text(
        itemCount.toString(),
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
      child: const Icon(Icons.shopping_cart),
    );
  });
}
