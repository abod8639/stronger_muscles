import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/constants/app_colors.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/presentation/bindings/profile_controller.dart';

class SavedAddressesList extends StatelessWidget {
  final ProfileController controller;
  final ThemeData theme;

  const SavedAddressesList({
    super.key,
    required this.controller,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      if (controller.addresses.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Saved Addresses',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.white : AppColors.black,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add New'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.addresses.length,
            itemBuilder: (context, index) {
              final address = controller.addresses[index];
              return _buildAddressCard(address, isDark);
            },
          ),
        ],
      );
    });
  }

  Widget _buildAddressCard(AddressModel address, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: address.isDefault
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                address.label == 'Home'
                    ? Icons.home_outlined
                    : address.label == 'Work'
                        ? Icons.work_outline
                        : Icons.location_on_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                address.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
              const Spacer(),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'DEFAULT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            address.fullName,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            address.fullAddress,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.greyDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            address.phoneNumber,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.greyDark,
            ),
          ),
        ],
      ),
    );
  }
}
