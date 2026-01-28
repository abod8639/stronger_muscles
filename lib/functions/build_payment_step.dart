
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/presentation/controllers/checkout_controller.dart';
import 'package:stronger_muscles/presentation/pages/checkout/checkout_view.dart';

Step buildPaymentStep(String title) {
    final controller = Get.find<CheckoutController>();
    return Step(
      title:  Text(title),
      content: Column(
        children: [
          buildPaymentOption(
            value: 'cod',
            title: 'Cash on Delivery',
            icon: Icons.money,
          ),
          const SizedBox(height: 8),
          buildPaymentOption(
            value: 'card',
            title: 'Credit Card',
            icon: Icons.credit_card,
            subtitle: 'Coming soon',
            enabled: false,
          ),
        ],
      ),
      isActive: controller.currentStep.value >= 1,
      state: controller.currentStep.value > 1
          ? StepState.complete
          : StepState.editing,
    );
  }

