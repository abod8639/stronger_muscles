import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/bindings/cart_controller.dart';

Widget cartIcon() {
  final controller = Get.put(CartController());
  return Obx(
    () {
      final itemCount = controller.cartItems.length; 
      return Badge(
        backgroundColor: AppColors.primary,
        isLabelVisible: itemCount > 0,
        label: Text(
          itemCount.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
        child: const Icon(
          Icons.shopping_cart,
        ),
      );
    },
  );
}