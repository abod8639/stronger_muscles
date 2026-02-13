import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/functions/show_address_form.dart';
import 'package:stronger_muscles/presentation/controllers/checkout_controller.dart';
import 'package:stronger_muscles/presentation/controllers/profile_controller.dart';

Step buildAddressStep(String title) {
  final checkoutController = Get.find<CheckoutController>();
  final profileController = Get.find<ProfileController>();

  return Step(
    title: Text(title),
    content: Builder(
      builder: (context) {
        return Column(
          children: [
            if (profileController.addresses.isEmpty)
              const Text('No addresses found. Please add one in your profile.')
            else
              Obx(
                () => Column(
                  children: profileController.addresses.map((address) {
                    final bool isSelected =
                        checkoutController.selectedAddress.value == address.id;
                    return Card(
                      elevation: isSelected ? 2 : 0,
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.05)
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: RadioListTile(
                        value: address,
                        groupValue: checkoutController.selectedAddress.value,
                        onChanged: (value) =>
                            checkoutController.setAddress(value!),
                        title: Text(
                          address.label ?? "error",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(address.fullAddress),
                        activeColor: AppColors.primary,
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                // Navigate to add address (placeholder for now)
                showAddressForm(context);
                // Get.snackbar('Info', 'Add address feature coming soon');
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Address'),
            ),
          ],
        );
      },
    ),
    isActive: checkoutController.currentStep.value >= 0,
    state: checkoutController.currentStep.value > 0
        ? StepState.complete
        : StepState.editing,
  );
}
