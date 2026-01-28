
  import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/presentation/controllers/checkout_controller.dart';

Widget buildPaymentOption({
    required String value,
    required String title,
    required IconData icon,
    String? subtitle,
    bool enabled = true,
  }) {
    return Obx(() {
      final controller = Get.find<CheckoutController>();
      final isSelected = controller.selectedPaymentMethod.value == value;
      return Card(
        elevation: isSelected ? 2 : 0,
        color: isSelected ? AppColors.primary.withOpacity(0.05) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: RadioListTile(
          value: value,
          groupValue: controller.selectedPaymentMethod.value,
          onChanged: enabled
              ? (val) => controller.setPaymentMethod(val.toString())
              : null,
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: enabled ? null : Colors.grey,
            ),
          ),
          subtitle: subtitle != null ? Text(subtitle) : null,
          secondary: Icon(
            icon,
            color: enabled ? AppColors.primary : Colors.grey,
          ),
          activeColor: AppColors.primary,
        ),
      );
    });
  }
