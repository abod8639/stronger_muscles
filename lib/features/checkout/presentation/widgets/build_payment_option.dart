import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/features/checkout/presentation/controllers/checkout_controller.dart';

Widget buildPaymentOption({
  required WidgetRef ref,
  required String value,
  required String title,
  required IconData icon,
  String? subtitle,
  bool enabled = true,
}) {
  final checkoutState = ref.watch(checkoutControllerProvider);
  final isSelected = checkoutState.selectedPaymentMethod == value;

  return Card(
    elevation: isSelected ? 2 : 0,
    color: isSelected ? AppColors.primary.withValues(alpha: .05) : null,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(
        color: isSelected ? AppColors.primary : Colors.grey.shade300,
      ),
    ),
    child: RadioListTile(
      value: value,
      groupValue: checkoutState.selectedPaymentMethod,
      onChanged: enabled
          ? (val) => ref
                .read(checkoutControllerProvider.notifier)
                .setPaymentMethod(val.toString())
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: enabled ? null : Colors.grey,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      secondary: Icon(icon, color: enabled ? AppColors.primary : Colors.grey),
      activeColor: AppColors.primary,
    ),
  );
}
